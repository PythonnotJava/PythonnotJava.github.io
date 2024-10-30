from gurobipy import *

dic = multidict({
    "k1" : [1, 2, 45],
    "k2" : [3, 65, 1]
})

print(dic)

from pympler import asizeof

class MyClass:
    def __init__(self, data):
        self.data : list = data

obj = MyClass([1, 2, 3, 67, 1, 2, 3, 671, 1, 2, 3, 617, 1, 2, 3, 67, 1, 2, 3, 67, 1, 2, 11])
print(asizeof.asizeof(obj.data))


