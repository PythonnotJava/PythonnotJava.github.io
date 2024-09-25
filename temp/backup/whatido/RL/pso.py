from pyswarm import pso
# PySwarms
def object_func(x):
    return ( 4+0.3*x[0]+0.0007*x[0]*x[0]+3+0.32*x[1]+0.0004*x[1]*x[1]+3.5+0.3*x[2]+0.00045*x[2]*x[2])

#不等式约束
def cons1(x):
    return [x[0]+x[1]+x[2]-700]

lb = [100, 120, 150] #
ub = [200, 250, 300]

xopt, fopt = pso(object_func, lb, ub, ieqcons=[cons1], maxiter=100, swarmsize=1000)
print(xopt)
print(fopt)

