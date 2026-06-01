def fib(n):
    if n <= 1:
        return n

    v = {x:None for x in range(n)}

    for x in range(2):
        v[x] = x

    for i in range(2, n+1):
        v[i] = v[i-1] + v[i-2]

    return v[n]

for x in [0,1,3,7,9,25, 99, 200, 20000]:
    print('Res for %s: %s' % (x, fib(x)))