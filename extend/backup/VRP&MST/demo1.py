import gurobipy

model = gurobipy.Model("model")
xs : gurobipy.tupledict = model.addVars(3, 4, lb=1, ub=5)

cs = model.addConstrs((xs.sum(i, "*") == 1 for i in range(3)))
model.setObjective()
model.update()
model.write('test.lp')