def multiply(x,y):
    if y == 0:
        return 0

    z = multiply(x, y/2)

    return 2 * z if (y % 2) == 0 else x + 2*z

for x in [(65536,65536)]:
    k, v = x
    print('%s x %s = %s' % (k, v, multiply(k,v)))
    