import gurobipy
from gurobipy import GRB
import numpy
from itertools import combinations

# 边的定义和距离矩阵的初始化
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

distances = numpy.full((16, 16), GRB.INFINITY)
for k, v in edges.items():
    i, j = k
    distances[i][j] = v
    distances[j][i] = v

numpy.fill_diagonal(distances, 0) # 自己到自己的距离为0

# 问题参数：客户数量和车辆数
n = 15  # 客户点数目
m = 3   # 车辆数目

# 创建优化模型
model = gurobipy.Model("VRP")

# 决策变量：X[k, i, j] 表示车辆k是否从i点行驶到j点
X = model.addVars(m, 1 + n, 1 + n, vtype=GRB.BINARY, name='X')

# 目标函数：最小化总行驶距离
objFunc = gurobipy.quicksum(
    distances[i, j] * X[k, i, j]
    for k in range(m)
    for i in range(n + 1)
    for j in range(n + 1)
)

model.setObjective(objFunc, GRB.MINIMIZE)

# 约束条件：每辆车从起点出发
for k in range(m):
    model.addConstr(gurobipy.quicksum(X[k, 0, j] for j in range(1, n + 1)) == 1)

# 约束条件：每辆车必须回到起点
for k in range(m):
    model.addConstr(gurobipy.quicksum(X[k, j, 0] for j in range(1, n + 1)) == 1)

# 流量平衡约束：每个客户点的进出流量必须相同
for k in range(m):
    for j in range(1, n + 1):
        model.addConstr(
            gurobipy.quicksum(X[k, i, j] for i in range(n + 1) if i != j) ==
            gurobipy.quicksum(X[k, j, i] for i in range(n + 1) if i != j)
        )

# 访问所有客户点的约束：每个客户点必须被访问一次
for j in range(1, n + 1):
    model.addConstr(
        gurobipy.quicksum(X[k, i, j] for k in range(m) for i in range(n + 1) if i != j) == 1
    )

# 禁止不可达的路径
for k in range(m):
    for i in range(n + 1):
        for j in range(n + 1):
            if distances[i, j] == GRB.INFINITY:
                model.addConstr(X[k, i, j] == 0)
            if i == j:
                model.addConstr(X[k, i, j] == 0)

# DFJ子回路消除约束：对于每一个真子集S，确保边数不超过|S|-1
for k in range(m):
    for S_size in range(2, n + 1):  # 从大小2的子集开始
        for S in combinations(range(1, n + 1), S_size):  # 获取顶点集合V的真子集S
            # 计算集合S中每一对节点i, j的连通边数
            model.addConstr(
                gurobipy.quicksum(X[k, i, j] for i in S for j in range(1, n + 1) if j not in S) +
                gurobipy.quicksum(X[k, j, i] for j in S for i in range(1, n + 1) if i not in S)
                <= S_size - 1
            )

# 更新模型并求解
model.update()
model.optimize()

# 检查是否找到最优解
if model.status == GRB.OPTIMAL:
    print(f"最小总行驶距离: {model.objVal}")

else:
    # print(f"没有找到最优解，状态码: {model.status}")
    model.computeIIS()
    model.write("model.lp")
