from functools import singledispatch

@singledispatch
def process(num=None):
    raise NotImplementedError("process func")

@process.register(int)
def sub_process(num):
    return f"Int {num}"

@process.register(float)
def sub_process(num):
    return f"Float {num}"

print(process(1))
print(process(12.0))
