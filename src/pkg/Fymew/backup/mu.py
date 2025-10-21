"""
伤感回忆钢琴曲 - 使用mingus生成（扩展版）
需要安装: pip install mingus
"""

from mingus.containers import Note, NoteContainer, Track, Composition
from mingus.midi import midi_file_out
import mingus.core.chords as chords

# 创建作曲
composition = Composition()
composition.set_author("AI Composer")
composition.set_title("Memories in Rain (雨中回忆) - Extended")

# 创建左右手音轨
right_hand = Track()
left_hand = Track()

# 设置速度 (BPM)
bpm = 65

# 定义和弦进行（左手伴奏）- 扩展版
chord_progression = [
    # 第一部分：引子与主题
    ('Am', 4), ('F', 4), ('C', 4), ('G', 4),
    ('Am', 4), ('Dm', 4), ('E7', 4), ('Am', 4),
    ('F', 4), ('G', 4), ('Em', 4), ('Am', 4),
    ('Dm', 4), ('G', 4), ('C', 4), ('Am', 4),

    # 第二部分：发展与回忆
    ('Am', 4), ('F', 4), ('C', 4), ('G', 4),
    ('Am', 4), ('Dm', 4), ('E7', 4), ('Am', 4),
    ('F', 4), ('G', 4), ('Em', 4), ('Am', 4),
    ('Dm', 4), ('G', 4), ('C', 4), ('E7', 4),

    # 第三部分：变奏（新增）
    ('Am', 4), ('C', 4), ('F', 4), ('Dm', 4),
    ('Bdim', 4), ('E7', 4), ('Am', 4), ('Am', 4),
    ('F', 4), ('G', 4), ('C', 4), ('Am', 4),
    ('Dm', 4), ('E7', 4), ('Am', 4), ('Am', 4),

    # 第四部分：情感高潮（新增）
    ('F', 4), ('G', 4), ('Am', 4), ('Am', 4),
    ('Dm', 4), ('E7', 4), ('Am', 4), ('C', 4),
    ('F', 4), ('G', 4), ('Em', 4), ('Am', 4),
    ('Dm', 4), ('G', 4), ('C', 4), ('Am', 4),
]

# 右手旋律音符
melody_phrases = [
    # === 第一部分：引子与主题 ===
    # 引子 - 孤独的开始
    [('A-4', 4), ('C-5', 4), ('E-5', 4), ('A-5', 8), ('G-5', 8), ('E-5', 4)],
    [('F-5', 4), ('E-5', 8), ('D-5', 8), ('C-5', 4), ('A-4', 4)],
    [('G-4', 4), ('B-4', 4), ('D-5', 4), ('E-5', 2)],
    [('E-5', 8), ('D-5', 8), ('C-5', 8), ('B-4', 8), ('A-4', 4), ('C-5', 4)],

    # 主题 - 回忆涌现
    [('A-5', 8), ('G-5', 8), ('E-5', 4), ('C-5', 8), ('D-5', 8), ('E-5', 4)],
    [('F-5', 4), ('A-5', 8), ('G-5', 8), ('F-5', 4), ('D-5', 4)],
    [('E-5', 8), ('F-5', 8), ('E-5', 8), ('D-5', 8), ('C-5', 4), ('B-4', 4)],
    [('A-4', 4), ('C-5', 8), ('E-5', 8), ('A-5', 2)],

    # 发展 - 情绪高涨
    [('C-6', 8), ('B-5', 8), ('A-5', 4), ('G-5', 4), ('F-5', 4)],
    [('G-5', 4), ('E-5', 8), ('F-5', 8), ('D-5', 4), ('E-5', 4)],
    [('E-5', 8), ('D-5', 8), ('C-5', 4), ('B-4', 4), ('A-4', 4)],
    [('A-4', 4), ('C-5', 4), ('E-5', 4), ('A-5', 4)],

    # 回忆片段 - 温柔回想
    [('D-5', 4), ('F-5', 8), ('E-5', 8), ('D-5', 4), ('C-5', 4)],
    [('B-4', 4), ('D-5', 4), ('G-5', 4), ('F-5', 8), ('E-5', 8)],
    [('C-5', 4), ('E-5', 4), ('G-5', 8), ('F-5', 8), ('E-5', 4)],
    [('E-5', 8), ('D-5', 8), ('C-5', 4), ('B-4', 4), ('A-4', 4)],

    # === 第二部分：深入回忆（优化旋律流畅度）===
    [('A-4', 4), ('C-5', 4), ('E-5', 4), ('A-5', 8), ('G-5', 8)],
    [('F-5', 4), ('E-5', 4), ('D-5', 4), ('C-5', 4)],
    [('G-4', 4), ('B-4', 4), ('D-5', 4), ('E-5', 4)],
    [('E-5', 4), ('D-5', 4), ('C-5', 4), ('B-4', 4)],

    [('A-4', 4), ('C-5', 4), ('E-5', 4), ('G-5', 8), ('F-5', 8)],
    [('F-5', 4), ('E-5', 4), ('D-5', 4), ('F-5', 4)],
    [('E-5', 4), ('D-5', 4), ('C-5', 4), ('B-4', 4)],
    [('C-5', 4), ('B-4', 4), ('A-4', 2)],

    # === 第三部分：变奏（新增）===
    # 更加细腻的情感表达
    [('A-5', 8), ('B-5', 8), ('C-6', 4), ('B-5', 8), ('A-5', 8), ('G-5', 4)],
    [('E-5', 4), ('G-5', 8), ('F-5', 8), ('E-5', 4), ('D-5', 4)],
    [('C-5', 8), ('D-5', 8), ('E-5', 4), ('D-5', 8), ('C-5', 8), ('B-4', 4)],
    [('A-4', 4), ('C-5', 4), ('E-5', 4), ('A-5', 4)],

    [('F-5', 4), ('E-5', 8), ('D-5', 8), ('C-5', 4), ('A-4', 4)],
    [('B-4', 4), ('D-5', 4), ('G-5', 8), ('F-5', 8), ('E-5', 4)],
    [('A-5', 8), ('G-5', 8), ('E-5', 4), ('C-5', 4), ('A-4', 4)],
    [('E-5', 8), ('D-5', 8), ('C-5', 4), ('B-4', 4), ('A-4', 4)],

    # === 第四部分：情感高潮（新增）===
    [('C-6', 4), ('B-5', 8), ('A-5', 8), ('G-5', 4), ('F-5', 4)],
    [('E-5', 4), ('F-5', 4), ('G-5', 8), ('A-5', 8), ('E-5', 4)],
    [('D-5', 4), ('E-5', 4), ('F-5', 4), ('E-5', 8), ('D-5', 8)],
    [('C-5', 4), ('E-5', 8), ('D-5', 8), ('C-5', 4), ('A-4', 4)],

    # 渐弱过渡
    [('F-5', 8), ('E-5', 8), ('D-5', 4), ('C-5', 4), ('B-4', 4)],
    [('B-4', 4), ('C-5', 4), ('D-5', 4), ('E-5', 4)],
    [('E-5', 8), ('D-5', 8), ('C-5', 4), ('B-4', 4), ('A-4', 4)],
    [('C-5', 8), ('B-4', 8), ('A-4', 4), ('E-4', 4), ('A-4', 4)],
]

def add_left_hand_pattern(track, chord_name, duration_per_note, variation=0):
    """添加左手分解和弦伴奏，支持不同变化"""
    try:
        chord_notes = chords.from_shorthand(chord_name)
        if len(chord_notes) >= 3:
            if variation == 0:
                # 标准分解和弦
                bass = Note(chord_notes[0], 3)
                track.add_notes(bass, duration_per_note * 2)

                nc1 = NoteContainer([Note(chord_notes[1], 3), Note(chord_notes[2], 4)])
                track.add_notes(nc1, duration_per_note)

                nc2 = NoteContainer([Note(chord_notes[0], 4), Note(chord_notes[2], 4)])
                track.add_notes(nc2, duration_per_note)
            elif variation == 1:
                # 和弦型伴奏（情感高潮处）
                bass = Note(chord_notes[0], 3)
                track.add_notes(bass, duration_per_note)

                nc = NoteContainer([Note(chord_notes[0], 4), Note(chord_notes[1], 4), Note(chord_notes[2], 4)])
                track.add_notes(nc, duration_per_note * 3)
    except:
        track.add_notes(None, duration_per_note * 4)

# 生成音乐
print("正在创作《雨中回忆 - 扩展版》...")
print("结构：引子 → 主题 → 发展 → 回忆 → 变奏 → 高潮 → 尾声")

# 遍历每个小节
for i, (chord_name, duration) in enumerate(chord_progression):
    # 在高潮部分使用不同的伴奏型
    variation = 1 if i >= 32 else 0

    # 左手：和弦伴奏
    add_left_hand_pattern(left_hand, chord_name, 8, variation)

    # 右手：旋律
    if i < len(melody_phrases):
        for note_name, note_duration in melody_phrases[i]:
            right_hand.add_notes(Note(note_name), note_duration)
    else:
        right_hand.add_notes(None, 1)

# 尾声 - 渐弱消失
print("添加尾声...")
ending_melody = [
    ('E-5', 8), ('C-5', 8), ('A-4', 4), ('C-5', 4), ('E-5', 4),
    ('A-5', 8), ('G-5', 8), ('E-5', 4), ('C-5', 4), ('A-4', 4),
    ('E-5', 4), ('D-5', 4), ('C-5', 4), ('B-4', 4),
    ('A-4', 2), ('C-5', 4), ('E-4', 2), ('A-4', 1)
]
for note_name, note_duration in ending_melody:
    right_hand.add_notes(Note(note_name), note_duration)

# 左手：结束和弦
left_hand.add_notes(Note('A-3'), 4)
left_hand.add_notes(Note('E-3'), 4)
left_hand.add_notes(Note('C-3'), 4)
left_hand.add_notes(NoteContainer([Note('A-2'), Note('E-3'), Note('A-3')]), 1)

# 添加音轨到作曲
composition.add_track(right_hand)
composition.add_track(left_hand)

# 导出MIDI文件
output_file = "memories_in_rain_extended.mid"
midi_file_out.write_Composition(output_file, composition, bpm=bpm)

print(f"\n✓ MIDI文件已生成: {output_file}")
print(f"  速度: {bpm} BPM")
print(f"  调性: A小调")
print(f"  时长: 约2分钟")
print(f"  段落: 7个部分，更丰富的情感层次")
print(f"\n请使用MIDI播放器播放此文件")
print("推荐播放器: Windows Media Player, VLC, MuseScore, GarageBand等")