import numpy as np
import random

# 参数设置
alpha = 0.1  # 学习率
gamma = 0.9  # 折扣因子
epsilon = 0.1  # 探索概率
num_episodes = 1000  # 训练次数

# 定义节点之间的距离
edges = {
    (0, 1): 4, (0, 3): 3.5, (0, 5): 6.2, (0, 7): 3.5, (0, 8): 6,
    (1, 2): 3.7, (1, 4): 4.5, (1, 9): 3,
    (2, 3): 3.4, (2, 10): 5.9,
    (4, 5): 3.3,
    (5, 10): 7.2, (5, 11): 3,
    (6, 10): 7, (6, 12): 7.3,
    (7, 12): 8.8, (7, 14): 5.8, (7, 15): 3.4,
    (8, 11): 11,
    (9, 14): 4.5,
    (10, 12): 7.5, (10, 13): 3.1,
    (12, 13): 4.3,
    (13, 15): 8.4,
    (14, 15): 6.9
}

# 构建 Q表，Q表的维度是节点数量×节点数量
num_nodes = 16
Q_table = np.zeros((num_nodes, num_nodes))

# 初始化从节点 A 出发
start_node = 0
num_vehicles = 3  # 车辆数量


def get_valid_actions(current_node, visited_nodes):
    """获取当前节点的可行动作，即所有连接的边"""
    actions = []
    for (i, j), dist in edges.items():
        if i == current_node and j not in visited_nodes:
            actions.append((j, dist))
        elif j == current_node and i not in visited_nodes:
            actions.append((i, dist))
    return actions


def choose_action(current_node, visited_nodes):
    """根据 epsilon-greedy 策略选择动作"""
    actions = get_valid_actions(current_node, visited_nodes)
    if not actions:  # 如果没有有效动作，返回 None
        return None
    if random.uniform(0, 1) < epsilon:
        # 探索：随机选择一个有效动作
        return random.choice(actions)
    else:
        # 利用：选择 Q 值最大的动作
        max_q_value = max([Q_table[current_node, action[0]] for action in actions])
        for action in actions:
            if Q_table[current_node, action[0]] == max_q_value:
                return action


def q_learning():
    """Q-learning 算法的主循环"""
    paths = [[] for _ in range(num_vehicles)]  # 用于存储每辆车的路径
    for vehicle in range(num_vehicles):
        current_node = start_node
        visited_nodes = set([current_node])

        while len(visited_nodes) < num_nodes:
            # 选择动作
            action = choose_action(current_node, visited_nodes)
            if action is None:
                break  # 如果没有可用的动作，跳出循环
            next_node, distance = action

            # 奖励机制：访问已访问节点的惩罚
            reward = -distance if next_node not in visited_nodes else -10

            # 更新 Q表
            best_next_action = max(Q_table[next_node, :]) if next_node < num_nodes else 0
            Q_table[current_node, next_node] += alpha * (
                        reward + gamma * best_next_action - Q_table[current_node, next_node])

            # 更新状态
            current_node = next_node
            visited_nodes.add(current_node)
            paths[vehicle].append(current_node)  # 记录路径

    return paths

# 执行训练
vehicle_paths = q_learning()

# 输出每辆车的路径
for i, path in enumerate(vehicle_paths):
    print(f"车辆 {i + 1} 的路径: {path}")
