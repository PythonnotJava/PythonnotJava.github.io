import numpy as np
import librosa
import librosa.display
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.metrics.pairwise import euclidean_distances
import json
import os


def detect_chorus_auto(audio_path, sr=22050, n_bins=72, hop_length=512, m=None, visualize=True):
    """自动自适应谱聚类副歌检测"""
    print(f"🎧 加载音频中：{audio_path}")
    y, sr = librosa.load(audio_path, sr=sr, mono=True)

    # 🥁 Beat tracking
    tempo, beats = librosa.beat.beat_track(y=y, sr=sr, hop_length=hop_length)
    tempo = float(np.atleast_1d(tempo)[0])
    beat_times = librosa.frames_to_time(beats, sr=sr, hop_length=hop_length)
    n_beats = len(beats)
    print(f"✅ 检测到 {n_beats} 个节拍, tempo={tempo:.1f} BPM")

    if n_beats < 8:
        raise ValueError("节拍太少，无法分析，请尝试另一首歌曲。")

    # 自动选择谱聚类维度
    if m is None:
        m = min(6, max(3, n_beats // 100))
    print(f"📊 自动选择聚类层次数 m={m}")

    # 🎼 特征提取
    C = np.abs(librosa.cqt(y, sr=sr, hop_length=hop_length, n_bins=n_bins))
    C_sync = librosa.util.sync(C, beats, aggregate=np.mean).T

    M = librosa.feature.mfcc(y=y, sr=sr, hop_length=hop_length, n_mfcc=13)
    M_sync = librosa.util.sync(M, beats, aggregate=np.mean).T

    rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=hop_length)[0]
    rms_sync = librosa.util.sync(rms, beats, aggregate=np.mean)

    # 📈 高斯相似度
    def gaussian_affinity(X, k=8):
        dist = euclidean_distances(X, X)
        sigma = np.mean(np.sort(dist, axis=1)[:, k])
        return np.exp(-dist**2 / (2 * sigma**2 + 1e-8))

    S_rep = gaussian_affinity(C_sync, k=8)
    S_loc = gaussian_affinity(M_sync, k=8)
    n = S_rep.shape[0]

    # 🔁 Recurrence matrix (Eq.1)
    k = 8
    knn = np.argsort(euclidean_distances(C_sync, C_sync), axis=1)[:, 1:k+1]
    R = np.zeros((n, n))
    for i in range(n):
        for j in knn[i]:
            if i in knn[j]:
                R[i, j] = 1
    R = np.maximum(R, R.T)

    # 平滑
    w = 3
    R_prime = np.zeros_like(R)
    for i in range(n):
        for j in range(n):
            votes = [R[i+t, j+t] for t in range(-w, w+1)
                     if 0 <= i+t < n and 0 <= j+t < n]
            R_prime[i, j] = np.round(np.mean(votes))

    # 序列连接 + 加权
    Delta = np.eye(n, k=1) + np.eye(n, k=-1)
    dR = np.sum(R_prime, axis=1)
    dD = np.sum(Delta, axis=1)
    mu = np.dot(dD, dR + dD) / (np.sum((dR + dD)**2) + 1e-8)
    A = mu * (R_prime * S_rep) + (1 - mu) * (Delta * S_loc)

    # 拉普拉斯矩阵
    D = np.diag(np.sum(A, axis=1))
    D_inv_sqrt = np.diag(1.0 / np.sqrt(np.sum(A, axis=1) + 1e-8))
    L = np.eye(n) - D_inv_sqrt @ A @ D_inv_sqrt
    L += np.eye(n) * 1e-6

    # 谱分解
    eigvals, eigvecs = np.linalg.eigh(L)
    eigvecs = eigvecs[:, :m]
    Y = eigvecs / (np.linalg.norm(eigvecs, axis=1, keepdims=True) + 1e-8)
    labels = KMeans(n_clusters=m, n_init=10, random_state=42).fit_predict(Y)

    # 找边界
    boundaries = np.where(np.diff(labels) != 0)[0]
    boundary_times = beat_times[boundaries]

    # 🔎 计算每段得分（重复度 + 能量）
    scores = []
    for k_label in set(labels):
        idx = np.where(labels == k_label)[0]
        submat = R_prime[np.ix_(idx, idx)]
        repeat_score = np.sum(submat)
        energy_score = np.mean(rms_sync[idx])
        scores.append(repeat_score * 0.7 + energy_score * 0.3)

    chorus_label = np.argmax(scores)
    chorus_start_idx = np.where(labels == chorus_label)[0][0]
    chorus_start_time = beat_times[chorus_start_idx]

    # 🧠 自动修正：避免前奏误判
    if chorus_start_time < 15:
        mid = len(beat_times)//3
        chorus_start_time = float(np.median(beat_times[mid:mid*2]))
        print(f"⚠️ 副歌过早，自动修正到中段 {chorus_start_time:.2f} 秒")

    print(f"🎵 最终副歌起点 ≈ {chorus_start_time:.2f} 秒")

    # 保存结果
    out_path = os.path.splitext(audio_path)[0] + "_chorus.json"
    data = {
        "file": os.path.basename(audio_path),
        "chorus_start_sec": float(chorus_start_time),
        "tempo": float(tempo),
        "segments": int(m)
    }
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"💾 结果已保存到: {out_path}")

    # 可视化
    if visualize:
        fig, ax = plt.subplots(1, 3, figsize=(15, 4))
        librosa.display.specshow(R_prime, x_axis='time', y_axis='time', ax=ax[0])
        ax[0].set_title("Recurrence matrix R′")

        ax[1].scatter(range(len(labels)), labels, c=labels, cmap='tab10', s=20)
        ax[1].set_title("Spectral clustering structure")
        ax[1].set_xlabel("Beat index")
        ax[1].set_ylabel("Segment label")

        min_len = min(len(beat_times), len(rms_sync))
        ax[2].plot(beat_times[:min_len], rms_sync[:min_len], color='gray')
        ax[2].axvline(chorus_start_time, color='r', linestyle='--', label='Chorus start')
        ax[2].set_title("RMS Energy vs Time")
        ax[2].set_xlabel("Time (s)")
        ax[2].legend()

        plt.tight_layout()
        plt.show()

    return chorus_start_time, boundary_times, labels


# 🧪 示例调用
if __name__ == "__main__":
    chorus_time, boundaries, labels = detect_chorus_auto(
        r"C:\Users\20281\Desktop\music\李荣浩 - 年少有为.mp3",
        visualize=True
    )
    print(f"\n🎯 副歌起点 ≈ {chorus_time:.2f} 秒")
