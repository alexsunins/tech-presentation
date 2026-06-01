def modulus(x, y):
    r = x

    while (x-y) % r != 0:
        r = r -1

    return r

print(modulus(253,13))