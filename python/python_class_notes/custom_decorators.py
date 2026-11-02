
def chaitu(func):
    print("Chaitu")
    def wrapper(*args,**kwargs):
        print("Chaitu inside a Wrapper")
        func(*args,**kwargs)
        print("End")
        return func
    return wrapper


@chaitu
def demo(a,b):
    print(a,b)


demo(a=10,b=20)


