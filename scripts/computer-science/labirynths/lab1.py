lab_map_1 = [
           [' ', ' ', ' ', '*', ' ', ' ', ' '],
           ['*', '*', ' ', '*', ' ', '*', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', '*', '*', '*', '*', '*', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', 'e']
          ]

lab_map_2 = [
           [' ', '*', '*', ' ', ' '],
           [' ', ' ', ' ', '*', ' '], 
           ['*', ' ', ' ', '*', 'e']
          ]

lab_map = [
           [' ', ' ', ' '],
           [' ', ' ', ' '],
           [' ', ' ', 'e']
          ]

def FindPath(row, col):
    step_queue.append((row, col))

    # check if we are not outside map boundaries
    if (col < 0 or row < 0) or (col >= map_width or row >= map_height):
        step_queue.pop()
        return

    # check if we found the exit
    if lab_map[row][col] == 'e':
        print('Found the exit!')
        printStepSequence()

    if lab_map[row][col] != ' ':
        # the current cell is not free
        step_queue.pop()
        return

    # mark current cell as visited
    lab_map[row][col] = 's'

    # invoke recursion to explore all possbile directions
    FindPath(row, col - 1) # left
    FindPath(row - 1, col) # up
    FindPath(row, col + 1) # right
    FindPath(row + 1, col) # down

    # mark current cell as free
    lab_map[row][col] = ' '


def findTurningPoint():
    pos = 0
    for x in step_queue:
        row, col = x
        if row == pos:
            pass
        else:
           if row == pos + 1:
               pos += 1
           else:
               return x


def printStepSequence():
    def _helper(step_queue):
        for x in step_queue:
            print(x)

        for x in step_queue:
            row, col = x
            path[row][col] = 'x'

        for x in range(map_height):
            print(path[x])
        
    
    # tp = findTurningPoint()
    tp = None

    if tp:
        tp_row, tp_col = tp
        idx = 0
        for x in step_queue:
            row, col = x; idx += 1
            if tp_row == row and tp_col == col + 1:
                new_step_queue = step_queue[:idx] + step_queue[step_queue.index(tp):]
                _helper(new_step_queue)
    else:
        _helper(step_queue)


    initPathMap()


def initPathMap():
    path.clear()
    for y in range(map_height):
        path.append([' ' for x in range(map_width)])


map_width = len(lab_map[0])
map_height = len(lab_map)

path = []
step_queue = []
step_queue_history = []

initPathMap()
FindPath(0, 0)