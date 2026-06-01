def divide(x, y):
    if x == 0:
        return (0,0)

    q, r = divide(x/2, y)

    q = 2*q
    r = 2*r

    if x % 2 == 1:
        r = r + 1
    elif r >= y:
        r = r - y
        q = q + 1

    return q, r

for x in [(100, 100)]:
    k, v = x
    print('dividing {0:b} on {1:b}'.format(k,v))
    print('%s / %s = %s' % (k, v, divide(k, v)))