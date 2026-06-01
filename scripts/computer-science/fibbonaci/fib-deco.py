def memoize(f):
    memo = {}

    def helper(x):
        if x not in memo:
            memo[x] = f(x)
        return memo[x]

    return helper

@memoize
def fib(n):
    return n if n in [0, 1] else fib(n-1) + fib(n-2)

print(fib(20000))