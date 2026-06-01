import sys


def pad(binary_str, pad_char, pad_depth, right_side=False):
    if len(binary_str) == pad_depth:
        return binary_str
    
    if right_side:
        return pad(binary_str + pad_char, pad_char, pad_depth, right_side)
    
    return pad(pad_char + binary_str, pad_char, pad_depth, right_side)


def dec_to_bin(number, binary_str=''):
    return pad(binary_str, '0', 8) if number == 0 else dec_to_bin(number // 2, str(number % 2) + binary_str)


def bin_to_dec(binary_str, idx=128, result=0):
    if len(binary_str) == 0:
        return result
    if binary_str[0] == '1':
        result = result + idx
    return bin_to_dec(binary_str[1:], idx // 2, result)


def split_to_octets(binary_str):
    octets = []
    for i in range(4):
        octets.append(str(bin_to_dec(binary_str[0:8])))
        binary_str = binary_str[8:]

    return '.'.join(octets)


def calc_addr(ip_addr_str, cidr):
    octets = ip_addr_str.split('.')

    binary_ip = ''
    for i in range(4):
        binary_ip = binary_ip + dec_to_bin(int(octets[i]))
    
    static_ip_addr_block = binary_ip[0:cidr]    

    first_addr = pad(static_ip_addr_block, '0', 32, right_side = True)
    last_addr = pad(static_ip_addr_block, '1', 32, right_side = True)

    return split_to_octets(first_addr), split_to_octets(last_addr)
    

# ip_addr='10.240.0.0'
# for cidr in range(8, 30):
#     first_address, last_address = calc_addr(ip_addr, cidr)
#     print(f'CIDR > {cidr} : {first_address} - {last_address}')

ip_addr_arg = sys.argv[1].split('/')
ip_addr = ip_addr_arg[0]
cidr = int(ip_addr_arg[1])

first_address, last_address = calc_addr(ip_addr, cidr)
print(f'CIDR > {cidr} : {first_address} - {last_address}')