def binary_multiply(x, y):
    def extract_lsb(x):
        return x >> 1, x & 1

    shifted_y, lsb = extract_lsb(y)

    if shifted_y == 0:
        return x
    else:
        return x * lsb + binary_multiply(x << 1, shifted_y)

    

print(binary_multiply(1024, 65536))