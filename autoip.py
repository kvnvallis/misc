#!/usr/bin/env python

from sys import exit

# auto complete an ip address
#
# 1.1.1.1 should return 1.1.1.1, 1.1.1.10-19, 1.1.1.100-199
# 1.1.1.199 should return 1.1.1.199

# Assumptions:
# 1) Subnet mask is 255.255.255.0, meaning any number between 1 and 254 is allowed in the last octet.
# 2) The first three octets must be provided as user input, because these values define which network the ip address belongs to. All possible addresses found by the auto-complete function will share the same network prefix.


def ipcount(num, allnums=list()):
    maxdigits = 3
    if int(num) >= 255:
        return
    elif len(num) == maxdigits:
        allnums.append(num)
    else:
        allnums.append(num)
        for n in range(10):
            ipcount(num + str(n))
        return allnums


def main():
    ipaddr = input('Enter an ip address...' + '\n> ')
    octets = ipaddr.split('.')

    try:
        if len(octets) > 4:
            raise ValueError('Too many octets')
        for group in octets:
            if len(group) > 3:
                raise ValueError('Too many digits in an octet')
            if int(group) < 1 or int(group) > 254:
                raise ValueError('Octet is out of range')
    except ValueError as e:
        print("Not a valid ip: " + str(e))
        exit()
        
    prefix = octets[0:3]
    hostid = octets[3]

    allnums = (ipcount(hostid))
    allips = list()
    for num in allnums:
        ipaddr = '.'.join(prefix + [num])
        print(ipaddr)


if __name__ == "__main__":
    main()

