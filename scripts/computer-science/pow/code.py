def get_steps(y):
   i = 0
   while True:
      if y < ( 2 << i ):
         return i - 1

      i += 1

def bin_multiply(x, y):
   # print(f'bin_multiply call - received {x} and {y}')

   if y == 0:
      return 0

   if y == 1:
      return x

   bit_shift_steps = get_steps(y)
   print(f'SHIFT STEPS: {bit_shift_steps}')

   remainder = y - ( 2 << bit_shift_steps )

   print(f'Will shift {x} by {bit_shift_steps} and add {x} times {remainder}')

   return ( x << bit_shift_steps + 1 ) + bin_multiply(x, remainder)


def multiply(x, y):
   #  print(f'Multiply call - received {x} and {y}')
    def extract_lsb(x):
        return x >> 1, x & 1

    shifted_y, lsb = extract_lsb(y)

    return x if shifted_y == 0 else ( bin_multiply(x, lsb) + multiply(x << 1, shifted_y) )

def fPow(base, exp):
   # print(f'fPow - received: {base} and {exp}')
   return base if exp == 1 else multiply(base, fPow(base, exp - 1))

base = 4
for x in [1, 2, 3, 4, 5, 6, 7, 8]:
   print(f'{base} to the power of {x} is: {fPow(base, x)}')
