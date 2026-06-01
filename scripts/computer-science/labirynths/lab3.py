import copy

lab_map_2 = [
           [' ', ' ', ' ', '*', ' ', ' ', ' '],
           ['*', '*', ' ', '*', ' ', '*', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', '*', '*', '*', '*', '*', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', 'e']
          ]

lab_map = [
           [' ', ' ', ' ', '*', ' ', ' ', ' '],
           ['*', '*', ' ', '*', ' ', '*', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', '*', '*', '*', '*', '*', ' '],
           [' ', ' ', ' ', '*', ' ', ' ', 'e']
          ]

def canGoUpFrom(row, col):
    # return False if row - 1 < 0 or lab_map[row-1][col] == '*' or visited[row-1][col] else True
    return False if row - 1 < 0 or lab_map[row-1][col] not in [' ', 'e'] else True

def canGoDownFrom(row, col):
    # return False if row + 1 > map_height - 1 or lab_map[row+1][col] == '*' or visited[row+1][col] else True
    return False if row + 1 > map_height - 1 or lab_map[row+1][col] not in [' ', 'e'] else True

def canGoLeftFrom(row, col):
    # return False if col - 1 < 0 or lab_map[row][col - 1] == '*' or visited[row][col-1] else True
    return False if col - 1 < 0 or lab_map[row][col-1] not in [' ', 'e'] else True

def canGoRightFrom(row, col):
    # return False if col + 1 > map_width - 1 or lab_map[row][col + 1] == '*' or visited[row][col+1] else True
    return False if col + 1 > map_width - 1 or lab_map[row][col+1]  not in [' ', 'e']  else True

def initVisited():
    return [[False for x in range(map_width)]for y in range(map_height)]


def printStepMap(step_history):
    lab_route = ' > '.join([str(x) for x in step_history])
    path_len.append({len(step_history): lab_route})

    print(lab_route)

    step_map = [[' ' for x in range(map_width)]for y in range(map_height)]
    for x in step_history:
        row, col = x
        step_map[row][col] = 'x'

    for x in step_map:
        print(x)


def Explore(row, col):
    global path_stack
    global step_history

    step_history.append((row, col))

    if lab_map[row][col] == 'e':
        print('Found the exit')

        route_history = []
        while len(route_stack) > 0:
            last_route = route_stack.pop()
            while len(last_route) > 0:
                x = last_route.pop()
                route_history.insert(0, copy.copy(x))
        print(f'Last route: {route_history}')
        step_history = route_history + step_history

        printStepMap(step_history)

        step_history.clear()
        step_history = route_history.copy()
        print(f'Popped step history: {step_history}')
        print(f'Rewinding >> current position: {step_history[-1]}')

        return

    lab_map[row][col] = 'v'

    directions = {'UP': False, 'DOWN': False, 'LEFT': False, 'RIGHT': False}

    if canGoUpFrom(row, col):
        directions['UP'] = True

    if canGoDownFrom(row, col):
        directions['DOWN'] = True

    if canGoLeftFrom(row, col):
        directions['LEFT'] = True

    if canGoRightFrom(row, col):
        directions['RIGHT'] = True

    where_to_go = [k for k, v in directions.items() if v]

    if not where_to_go:
        print(f'From ({row}, {col}) got nowhere to go')
        if route_stack:
            step_history = route_stack.pop()
            print(f'Nowhere to go, stack state: {route_stack}, curr_step_hst: {step_history}')
        else:
            print('Stack is empty')
        return

    if len(where_to_go) > 1:
        print(f'(From ({row}, {col}) can go {where_to_go}')
        route_stack.append(step_history.copy())
        print(f'Stack: {route_stack}')
        step_history.clear()

    for way in where_to_go:
        print(f'Going {way}')
        if way == 'UP':
            Explore(row - 1, col)
        if way == 'DOWN':
            Explore(row + 1, col)
        if way == 'LEFT':
            Explore(row, col - 1)
        if way == 'RIGHT':
            Explore(row, col + 1)

    lab_map[row][col] = ' '

path_len = []

map_width = len(lab_map[0])
map_height = len(lab_map)

step_history = []
route_stack = []

visited = initVisited()
Explore(0,0)

shortest_route = min(y for x in path_len for y in x.keys()) 
longest_route = max(y for x in path_len for y in x.keys())

if shortest_route != longest_route:
    print(f'Shortest Route: {shortest_route} steps')
    print(f'Longest Route: {longest_route} steps')
else:
    print(f'Discovered paths are all of the same length: {shortest_route} steps')