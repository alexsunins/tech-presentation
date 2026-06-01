import copy

lab_map_2 = [
           [' ', ' ', ' ', '*', ' ', ' ', ' '],
           ['*', '*', ' ', '*', ' ', '*', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', '*', '*', '*', '*', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', 'e']
          ]

lab_map = [
           [' ', ' ', ' ', '*', ' ', ' ', '*'],
           ['*', '*', ' ', '*', ' ', '*', 'e'],
           [' ', ' ', ' ', ' ', ' ', '*', ' '],
           [' ', '*', '*', ' ', ' ', ' ', ' '],
           [' ', '*', ' ', ' ', '*', ' ', '*'],
           [' ', '*', '*', ' ', '*', ' ', '*'],
           [' ', ' ', ' ', ' ', ' ', ' ', '*'],
          ]

wall_chr = chr(0x2588)
white_space_chr = chr(0x2591)
#direction_arrow = {'LEFT': chr(0x21D0), 'RIGHT': chr(0x21F0), 'UP': chr(0x21E7), 'DOWN': chr(0x21D3), None: 's'}
direction_arrow = {'LEFT': '<', 'RIGHT': '>', 'UP': '^', 'DOWN': 'V', None: 's'}


disallowed_destinations = [v for k, v in direction_arrow.items()] + [wall_chr]


def canGoUpFrom(row, col):
    return False if row - 1 < 0 or lab_map[row - 1][col] in disallowed_destinations  else True

def canGoDownFrom(row, col):
    return False if row + 1 > map_height - 1 or lab_map[row + 1][col] in disallowed_destinations  else True

def canGoLeftFrom(row, col):
    return False if col - 1 < 0 or lab_map[row][col - 1] in disallowed_destinations  else True

def canGoRightFrom(row, col):
    return False if col + 1 > map_width - 1 or lab_map[row][col + 1] in disallowed_destinations else True


def printStepHistory(step_history):
    print(f'{len(step_history)} steps')
    step_log = ' > '.join([str(x) for x in step_history])
    print(f'{step_log}')
    printTheMap()


def Explore(row, col, direction=None):
    global step_history
    global route_stack
    global lab_map
    global last_map_state


    def pushStack():
        route_stack.insert(len(route_stack), [copy.copy(x) for x in step_history])
        current_map_state = [copy.copy(x) for x in lab_map]
        map_state_stack.insert(len(map_state_stack), current_map_state)


    def popStack():
        last_step_history = route_stack.pop()
        last_map_state = map_state_stack.pop()
        return [copy.copy(x) for x in last_step_history], [copy.copy(x) for x in last_map_state]

        
    step_history.insert(len(step_history), (row, col))

    if lab_map[row][col] == 'e':
        print('\nFound the exit')

        # merge contents of route_stack with step_history
        route_stack_copy = [copy.copy(x) for x in route_stack]
        while len(route_stack_copy) > 0:
            map_route = route_stack_copy.pop()
            while len(map_route) > 0:
                v = map_route.pop()
                step_history.insert(0, v)

        printStepHistory(step_history)

        path_len.append({len(step_history): step_history})

        if route_stack:
            step_history, lab_map = popStack()

        return

    lab_map[row][col] = direction_arrow[direction]

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
        # print(f'From ({row}, {col}) got nowhere to go')
        if route_stack:
            step_history, lab_map = popStack()

        return

    if len(where_to_go) > 1:
        # print(f'(From ({row}, {col}) can go {where_to_go}')
        pushStack()
        step_history.clear()

    for way in where_to_go:
        #print(f'Going {way}')
        if way == 'UP':
            Explore(row-1, col, way)
        if way == 'DOWN':
            Explore(row + 1, col, way)
        if way == 'LEFT':
            Explore(row, col - 1, way)
        if way == 'RIGHT':
            Explore(row, col + 1, way)

def colorTheMap():
    for y in range(map_height):
        for x in range(map_width):
            print(x, y)
            if lab_map[y][x] == '*':
                lab_map[y][x] = wall_chr
            if lab_map[y][x] == ' ':
                lab_map[y][x] = white_space_chr

def printTheMap():
    for y in range(map_height):
        s = ''.join(['{:4s}' for x in range(map_width)])
        s = s.format(*lab_map[y])
        print(s)


map_width = len(lab_map[0])
map_height = len(lab_map)

print(f'Map dimensions: {map_width} by {map_height}')

map_state_stack = []

step_history = []
route_stack = []

path_len = []

colorTheMap()

Explore(0, 0)

if path_len:
    shortest_path = min(y for x in path_len for y in x.keys())
    longest_path = max(y for x in path_len for y in x.keys())

    print(f'Shortest route: {shortest_path} steps,\nLongest route: {longest_path} steps')
else:
    print('No exits found')