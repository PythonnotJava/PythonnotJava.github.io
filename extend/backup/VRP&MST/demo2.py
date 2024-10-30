"""
max: x + y + 2z
s.t. x + 2y + 3z <= 4
     x + y >= 1

     x, y, z ∈{0, 1}
"""


from gurobipy import *

model = Model("model")

x = model.addVar(lb=0, ub=1, vtype=GRB.BINARY, name='xaxis')
y = model.addVar(lb=0, ub=1, vtype=GRB.BINARY, name='yaxis')
z = model.addVar(lb=0, ub=1, vtype=GRB.BINARY, name='zaxis')

objectFunc = model.setObjective(x + y + 2 * z, sense=GRB.MAXIMIZE)

constraint1 = model.addConstr(x + 2 * y + 3 * z <= 4, name='constraint1')
constraint2 = model.addConstr(x + y >= 1, name='constraint2')

model.update()
model.optimize()

xvar : Var = model.getVarByName('xaxis')
print(xvar.x)
