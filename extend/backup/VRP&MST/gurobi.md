## Model类型功能
| 函数           | 返回类型      | 功能       |
|--------------|-----------|----------|
| addVar       | Var       | 添加变量     |
| addVars      | tupledict | 添加多个变量   |
| addConstr    | Constr    | 添加约束     |
| addConstrs   | tupledict | 添加多个约束   |
| update       | None      | 更新求解器    |
| write        | None      | 用于存储模型   |
| setObjective | None      | 设置目标函数   |
| optimize     | None      | 开始优化     |
| getVars      | list[Var] | 获取变量集    |
| getVarByName | Var       | 根据名字获取变量 |
|              |           |          |
|              |           |          |
|              |           |          |
|              |           |          |
|              |           |          |
|              |           |          |
|              |           |          |

## Gurobi流水线推荐
1. 建立变量
2. 设置目标函数
3. 建立约束
4. 优化


## Gurobi 中，变量的类型（vtype）主要有以下几种：
1. Continuous (C): 连续变量，可以取任意实数值。
2. Integer (I): 整数变量，只能取整数值。
3. Binary (B): 二进制变量，只能取 0 或 1 的值。
4. Semi-Continuous (S): 半连续变量，如果变量大于零，则它的值可以是任意非负实数；如果等于零，则必须为零。
5. Semi-Integer (S): 半整数变量，类似于半连续变量，但只能取整数值。

## Gurobi 中，setObjective 的 sense 参数用于指定目标函数的优化方向，主要有两个选项：
1. GRB.MINIMIZE: 表示最小化目标函数。
2. GRB.MAXIMIZE: 表示最大化目标函数。

## Gurobi 中，Var 类的属性用于描述和操作变量。以下是这些属性的简要说明：
1. obj: 线性目标函数系数。可以设置，影响目标函数的计算。
2. lb: 变量的下界。可以设置，限制变量的最小值。
3. ub: 变量的上界。可以设置，限制变量的最大值。
4. varName: 变量的名称。可以设置，便于识别和调试。
5. vType: 变量的类型，取值包括：
6. x: 最优解时变量的值。只能查询，表示求解后的结果。
7. rc: 解的缩减成本。对于线性规划，表示增加该变量的值对目标函数的影响。
8. xn: 在替代 MIP 解中的变量值。用于探索不同的解。


