def demo(a:int,b:int):
    print(a+b)

demo("10","20")


def var_demo(*args):
    print(args)

var_demo(10,20,30)

def var_demo2(**kwargs):
    print()
    print(kwargs)

var_demo2(a=10,b=20,c=30)