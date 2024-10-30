# 并查集辅助函数
class UnionFind:
    def __init__(self, nodes):
        # 初始化每个节点的父节点为其自身，秩为 0
        self.parent = {node: node for node in nodes}
        self.rank = {node: 0 for node in nodes}

    def find(self, node):
        # 路径压缩优化
        if self.parent[node] != node:
            self.parent[node] = self.find(self.parent[node])
        return self.parent[node]

    def union(self, node1, node2):
        # 查找两个节点的根节点，并进行合并
        root1 = self.find(node1)
        root2 = self.find(node2)

        if root1 != root2:
            # 按秩合并
            if self.rank[root1] > self.rank[root2]:
                self.parent[root2] = root1
            elif self.rank[root1] < self.rank[root2]:
                self.parent[root1] = root2
            else:
                self.parent[root2] = root1
                self.rank[root1] += 1


# Kruskal 算法求解最小生成树
def kruskal_mst(edges):
    # 提取节点集合
    nodes = set()
    for edge in edges:
        nodes.add(edge[0])
        nodes.add(edge[1])

    # 初始化并查集
    uf = UnionFind(nodes)

    # 将边按权重从小到大排序
    sorted_edges = sorted(edges, key=lambda x: x[2])

    mst = []  # 存储最小生成树的边
    total_weight = 0  # 最小生成树的总权重

    for edge in sorted_edges:
        node1, node2, weight = edge
        # 如果两个节点不在同一个集合，则添加该边到最小生成树，并合并集合
        if uf.find(node1) != uf.find(node2):
            uf.union(node1, node2)
            mst.append(edge)
            total_weight += weight

    return mst, total_weight


# 定义边集
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
]

# 运行 Kruskal 算法
mst, total_weight = kruskal_mst(edges)

# 输出结果
print("最小生成树的边：")
for edge in mst:
    print(f"边 {edge[0]} - {edge[1]}，权重: {edge[2]}")
print(f"最小生成树的总权重: {total_weight}")
