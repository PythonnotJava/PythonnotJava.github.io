import librosa
import numpy as np
from scipy.linalg import eigh
from sklearn.neighbors import NearestNeighbors
from sklearn.cluster import KMeans


# --- 1. 辅助函数：相似度计算和矩阵操作 ---

def compute_gaussian_affinity(X, sigma_sq=None):
    """根据特征矩阵 X 计算高斯核亲和矩阵 S"""
    n = X.shape[0]

    # *** 修复点 1：样本点过少时的保护 ***
    if n <= 1:
        # 无法计算相似度，返回一个平凡结果
        return np.ones((n, n)), 1.0

    # 计算平方欧氏距离矩阵
    D_sq = np.sum(X ** 2, axis=1, keepdims=True) + \
           np.sum(X ** 2, axis=1, keepdims=True).T - \
           2 * (X @ X.T)

    if sigma_sq is None:
        # 估计带宽 sigma^2 (kNN平均平方距离)
        k_theory = int(1 + np.ceil(2 * np.log2(n)))

        # *** 修复点 2：确保 k_neighbors 不超过样本数 ***
        # k 是要找的邻居数量 (不包括自己)。n_neighbors = k + 1 (包括自己)
        k = min(k_theory, n - 1)
        if k < 1:
            k = 1  # 至少找 1 个邻居

        # 找到每个点的第 k 个最近邻居的距离
        nn = NearestNeighbors(n_neighbors=k + 1, metric='sqeuclidean')
        nn.fit(X)

        # 错误发生在这里，如果 n_samples_fit < n_neighbors，则会报错。
        # 由于我们设置了 k = min(k_theory, n - 1)，因此 n_neighbors = k+1 <= n，已经避免了错误。
        distances, _ = nn.kneighbors(X)

        # 第 k 个最近邻的平方距离在 distances[:, k]
        sigma_sq = np.mean(distances[:, k]) / 2.0
        if sigma_sq == 0 or np.isnan(sigma_sq):
            sigma_sq = 1e-6  # 避免除以零或 NaN

    # S_ij = exp(-1/(2*sigma^2) * ||x_i - x_j||^2)
    S = np.exp(-D_sq / (2 * sigma_sq))
    return S, sigma_sq


def majority_vote_filter(R, w=17):
    """
    对递归矩阵 R 应用窗口多数投票平滑（沿对角线）。
    w 是最小有效重复序列的长度（窗口大小）。
    """
    n = R.shape[0]
    R_prime = np.zeros_like(R)

    # 窗口大小 (2*w + 1)
    kernel_size = 2 * w + 1

    # 对于每个对角线 k (k=i-j)
    for k in range(-n + 1, n):
        diag_indices = np.arange(n)
        i = diag_indices + k
        j = diag_indices
        valid_indices = (i >= 0) & (i < n) & (j >= 0) & (j < n)

        if np.any(valid_indices):
            i_valid = i[valid_indices]
            j_valid = j[valid_indices]
            diag_vals = R[i_valid, j_valid]

            # 使用 numpy.convolve 进行滑动窗口求和
            padded_diag = np.pad(diag_vals, w, mode='constant', constant_values=0)
            sum_filter = np.convolve(padded_diag, np.ones(kernel_size), mode='valid')

            # 如果窗口内的和大于窗口大小的一半，则为多数票（即1）
            majority_mask = (sum_filter > kernel_size / 2.0)

            # 将结果写回 R_prime
            R_prime[i_valid[majority_mask], j_valid[majority_mask]] = 1

    return R_prime


# --- 2. 核心算法步骤 ---

def laplacian_structural_decomposition(audio_path, M_max=10, min_segment_duration=10):
    """
    根据论文 实现拉普拉斯结构分解 (Algorithm 2)。
    """
    SR = 22050
    HOP_LENGTH = 512
    N_FFT = 2048

    # 1. 加载音频并检测节拍
    print("1. 特征提取...")
    y, sr = librosa.load(audio_path, sr=SR)
    tempo, beats = librosa.beat.beat_track(y=y, sr=sr, hop_length=HOP_LENGTH)

    # --- 节拍同步和时延嵌入 ---

    # 2. 提取 S_rep 特征 (CQT, 谐波)
    cqt = librosa.cqt(y, sr=sr, hop_length=HOP_LENGTH, bins_per_octave=12,
                      n_bins=72, fmin=librosa.note_to_hz('C2'))
    cqt_log = librosa.amplitude_to_db(np.abs(cqt) ** 2, ref=np.max).T
    CQT_sync = librosa.util.sync(cqt_log, beats)

    # 时延嵌入 (一步历史)
    if CQT_sync.shape[0] >= 2:
        X_rep = np.vstack([CQT_sync[1:], CQT_sync[:-1]]).T
        X_rep = X_rep[1:]  # 确保与 beats 数量匹配
    else:
        # 如果节拍少于 2 个，则 X_rep 为空，交由下一步的 n 检查处理
        X_rep = np.array([])

    # 3. 提取 S_loc 特征 (MFCC, 音色)
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13, hop_length=HOP_LENGTH).T
    MFCC_sync = librosa.util.sync(mfccs, beats)

    if MFCC_sync.shape[0] >= 2:
        X_loc = MFCC_sync[1:]  # 确保与 beats 数量匹配
    else:
        X_loc = np.array([])

    # 重新确定 n（节拍帧数）
    n = X_rep.shape[0]

    # *** 修复点 3：检查节拍帧数，处理短音频 ***
    if n < 2:
        print(f"\n[错误] 检测到的节拍帧数过少 (n={n})，无法进行谱聚类结构分析。")
        print("请确保 'a.mp3' 文件足够长（建议 > 5秒）且节奏清晰。")
        return {}, None

    # 4. 计算相似度矩阵
    S_rep, sigma_sq_rep = compute_gaussian_affinity(X_rep)
    S_loc, sigma_sq_loc = compute_gaussian_affinity(X_loc)

    # --- 2.2 序列增强亲和矩阵 A 的构建 ---
    print("2. 构建亲和矩阵...")

    # 1. 递归矩阵 R' 的构建
    k_theory = int(1 + np.ceil(2 * np.log2(n)))
    # *** 修复点 4：确保 k_neighbors <= n ***
    k = min(k_theory, n - 1)

    nn = NearestNeighbors(n_neighbors=k + 1, metric='euclidean')
    nn.fit(X_rep)
    distances, indices = nn.kneighbors(X_rep)

    R = np.zeros((n, n), dtype=int)
    for i in range(n):
        for j in indices[i, 1:]:  # 排除自身
            # 互 k-NN 检查: 如果 i 是 j 的 k-NN，且 j 是 i 的 k-NN
            if i in indices[j, 1:]:
                # 排除 3 个节拍内的连接 (局部连接由 Delta 处理)
                if np.abs(i - j) > 3:
                    R[i, j] = 1

    R_prime = majority_vote_filter(R, w=17)  # 窗口多数投票

    # 2. 局部连接矩阵 Delta
    Delta = np.diag(np.ones(n - 1), 1) + np.diag(np.ones(n - 1), -1)

    # 3. 计算最优权重 mu*
    d_R_prime = np.sum(R_prime, axis=1)  # R' 的度向量
    d_Delta = np.sum(Delta, axis=1)  # Delta 的度向量

    # 计算 mu*
    if np.sum(d_R_prime + d_Delta) == 0:
        mu_star = 0.5
    else:
        numerator = np.dot(d_Delta, d_R_prime + d_Delta)
        denominator = np.dot(d_R_prime + d_Delta, d_R_prime + d_Delta)
        mu_star = np.clip(numerator / denominator, 0, 1)

    # 4. 序列增强亲和矩阵 A
    A = mu_star * (R_prime * S_rep) + (1 - mu_star) * (Delta * S_loc)

    # --- 2.3 谱分解和迭代分割 (Algorithm 2) ---
    print(f"3. 谱分解 (mu*={mu_star:.3f})...")

    # 1. 计算归一化拉普拉斯 L
    D = np.diag(np.sum(A, axis=1))
    # 避免 D 出现零度（通常不会，但需保护）
    if np.any(np.diag(D) == 0):
        print("[警告] 度矩阵 D 出现零度。")
        D[np.diag(D) == 0] = 1e-6  # 避免除以零

    D_inv_sqrt = np.linalg.matrix_power(D, -0.5)
    L = np.eye(n) - D_inv_sqrt @ A @ D_inv_sqrt

    # 2. 提取特征向量 Y
    # eigh 自动按升序排列特征值
    _, Y_full = eigh(L)

    # 3. 迭代 M_max 得到不同复杂度的分割
    results = {}
    for m in range(2, M_max + 1):
        if m > n: continue  # 聚类数不能超过样本数

        Y_m = Y_full[:, :m]  # 提取前 m 个特征向量

        # 边界检测 (Algorithm 1)
        Y_norm = Y_m / np.linalg.norm(Y_m, axis=1, keepdims=True)

        kmeans = KMeans(n_clusters=m, random_state=0, n_init='auto')
        C = kmeans.fit_predict(Y_norm)

        boundaries_idx = np.where(C[:-1] != C[1:])[0]

        results[m] = {'boundaries': boundaries_idx, 'labels': C}

    # --- 2.4 自动选择最佳 m（用于推荐副歌起点）---
    print("4. 自动选择最佳 m (基于最大熵和最小持续时间)...")

    best_m = None
    max_entropy = -1

    # 将 beats 索引转换为时间（秒）
    beats_time = librosa.frames_to_time(beats[1:n + 1], sr=sr)  # 对应于 X_rep/X_loc 的节拍时间

    for m, res in results.items():
        boundaries_idx = res['boundaries']

        # 约束 1: 最小平均段落持续时间
        # 边界时间点：从 0 开始，到所有边界索引，再到歌曲结束时间
        boundary_time_points = beats_time[boundaries_idx]
        all_time_points = np.insert(boundary_time_points, 0, 0)
        # 歌曲总时长
        song_duration = librosa.get_duration(y=y, sr=sr)
        all_time_points = np.append(all_time_points, song_duration)

        segment_lengths = np.diff(all_time_points)

        if len(segment_lengths) == 0:
            avg_duration = song_duration
        else:
            avg_duration = np.mean(segment_lengths)

        if avg_duration >= min_segment_duration:
            # 约束 2: 最大化帧级注释熵
            labels, counts = np.unique(res['labels'], return_counts=True)
            probabilities = counts / len(res['labels'])
            entropy = -np.sum(probabilities * np.log2(probabilities + 1e-10))  # 加一个微小值防止 log(0)

            if entropy > max_entropy:
                max_entropy = entropy
                best_m = m

    # --- 2.5 确定副歌起点（将索引转换为时间）---

    if best_m is not None:
        best_boundaries_idx = results[best_m]['boundaries']
        # 转换成秒
        best_boundaries_time = beats_time[best_boundaries_idx]

        print(f"\n--- 最佳分割 m={best_m} (Max Entropy) ---")
        print(f"检测到的边界时间 (秒): {best_boundaries_time}")
        print("\n**副歌起点识别提示:**")
        print("副歌起点（例如：第一次出现副歌的时间）将是这些边界时间点之一。")
        print("因为该方法是无监督的，你可能需要根据每个段落的特征（如响度、音高变化等）或人工聆听，")
        print(f"从这 {len(best_boundaries_time)} 个时间点中确定哪个是副歌的开始。")

        return results, best_boundaries_time
    else:
        print("\n[结果] 未找到满足最小段落时长约束（10秒）的分割。")
        print("请检查你的音频文件或放松约束条件。")
        return results, None


# --- 运行示例 (你需要提供一个 a.mp3 文件) ---
if __name__ == '__main__':
    # 请确保安装了所有必要的库:
    # pip install librosa numpy scipy scikit-learn

    SONG_PATH = r"C:\Users\20281\Desktop\music\李荣浩 - 年少有为.mp3"

    try:
        # 运行结构分解
        results, boundaries = laplacian_structural_decomposition(SONG_PATH)

        if boundaries is not None:
            print("\n-------------------------------------------")
            print(f"建议的结构边界时间点列表: {boundaries}")
            print("-------------------------------------------")

    except FileNotFoundError:
        print(f"\n[致命错误] 找不到文件 {SONG_PATH}。请确保文件存在于脚本运行目录下。")
    except Exception as e:
        print(f"\n[致命错误] 运行过程中发生未知错误: {e}")