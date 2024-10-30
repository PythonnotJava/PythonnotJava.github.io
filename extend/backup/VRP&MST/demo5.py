import gurobipy
from gurobipy import GRB

# 点数目
n = 16
# 点名字
nodes = [chr(x) for x in range(n + 65)]

# 距离邻接矩阵
edges = [
    ('A', 'B', 4), ('A', 'D', 3.5), ('A', 'F', 6.2), ('A', 'G', 3.5), ('A', 'H', 6),
    ('B', 'C', 3.7), ('B', 'E', 4.5), ('B', 'I', 3),
    ('C', 'D', 3.4), ('C', 'J', 5.9),
    ('E', 'F', 3.3),
    ('F', 'K', 7.2), ('F', 'L', 3),
    ('G', 'K', 7), ('G', 'M', 7.3),
    ('H', 'M', 8.8), ('H', 'O', 5.8), ('H', 'P', 3.4),
    ('I', 'L', 11),
    ('J', 'O', 4.5),
    ('K', 'L', 7.5), ('K', 'M', 3.1),
    ('M', 'N', 4.3),
    ('N', 'P', 8.4),
    ('O', 'P', 6.9)
]  # len == 25

# 创建模型
model = gurobipy.Model('mst')

# 建立变量，X[i,j]表示边(i,j)是否被选中
X = model.addVars(edges, vtype=GRB.BINARY, name="X")

# 目标函数：最小化边的权重和
model.setObjective(gurobipy.quicksum(X.select(i, j, '*')[0] * w for i, j, w in edges), GRB.MINIMIZE)

# 添加约束：选择的边数等于节点数减一
model.addConstr(gurobipy.quicksum(X.select(i, j, '*')[0] for i, j, w in edges) == n - 1, "edge_count")

# 求解模型
model.update()
model.optimize()

# 输出结果
if model.status == GRB.OPTIMAL:
    print("最优解找到")
    ws = 0.0
    for i, j, w in edges:
        if X.select(i, j, '*')[0].X > 0.5:
            print(f"边 ({i}, {j}) 被选中，权重: {w}")
            ws += w
    print("总权重：%f" % ws)
else:
    print("没有找到最优解")
