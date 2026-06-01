from random import randint

def merge(left, right):
    # print(f'Left: {left}, Right: {right}')
    if type(left) == int:
        left = [left]
    if type(right) == int:
        right = [right]

    if not left:
        return right
    if not right:
        return left
    elif left[0] <= right[0]:
        return [left[0]] + merge(left[1:], right)
    else:
        return [right[0]] + merge(left, right[1:])

def mergesort(arr):
    arr_len = len(arr)
    arr_middle = arr_len // 2
    left_part = arr[:arr_middle]
    right_part = arr[arr_middle:]

    if arr_len > 1:
        return merge(mergesort(left_part), mergesort(right_part))
    else:
        return arr

def itermergesort(arr):
    def inject(item, arr=[]):
        arr.insert(len(arr), item)

    def eject(arr):
        a = arr.pop()
        return a

    q = []
    for x in range(len(arr)):
        inject(arr[x], q)

    while len(q) > 1:
        inject(merge(eject(q), eject(q)), q)

    return q[0]

def get_random_number(threshold):
    return randint(0, threshold)


# generate list with unique random numbers
def get_list_with_unique_items(threshold):
    a = []
    idx = 0
    while idx != threshold:
        rnd_num = get_random_number(threshold)

        if rnd_num not in a:
            a.insert(len(a), rnd_num)
            idx += 1

    return a


item_count = 320
a = get_list_with_unique_items(item_count)
print(f'Initial array: {a}')
print(itermergesort(a))