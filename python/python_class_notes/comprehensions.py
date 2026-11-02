# list comprehensions
print("list comprehensions")

l = [int(x) for x in range(10)]
print(l)

# dict comprehensions
print("dict comprehensions")
dicts = {a:b for a,b in enumerate(range(10,5,-2),21)}
print(dicts)

# conditional comprehensions
print("conditional comprehensions")
cl= [x for x in range(10) if x%2==0]
print(cl)

v = [x if x%2==0 else "odd" for x in range(10)]
print(v)
