def get_steps(y):
   i = 0
   while True:
      if y < ( 2 << i ):
         return i - 1

      i += 1

def multiply(x, y):
   print(f'Received x: {x} and y {y}')
   if y == 1:
      return x
   bit_shift_steps = get_steps(y)

   remainder = y - ( 2 << bit_shift_steps )

   print(f'Will shift {x} by {bit_shift_steps} and add {x} times {remainder}')

   return ( x << bit_shift_steps + 1 ) + multiply(x, remainder)

a = 25
b = 3

print(multiply(a, b))
