def tag_order(order_id, tags=[]):
    print("Tags ",tags)
    tags.append(order_id)
    return tags

a = tag_order(100)
b = tag_order(200)
c = tag_order(300)
# print(tags)
# print(a,b)
print("a",a)
print("b",b)
