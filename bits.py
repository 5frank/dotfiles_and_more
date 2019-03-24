#!/usr/bin/env python3 
import argparse
import sys
from math import ceil, log

def _toint(x):
    return int(x, 0)

parser = argparse.ArgumentParser(
        description='Pretty print bits. Like hexdump but for bits',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('value', metavar='INTVAL', type=_toint, nargs='+',
                help='One or more hex or decimal integer values')

parser.add_argument('--nbits', '-n', '-w', metavar='NBITS', type=int, 
        default=32,  
        help='number of bits per line. eg. word size. \
                will be overridden if passed value do not fit and always \
                rounded up to closest multiple of four')

parser.add_argument('--bigend', '-b', action='store_true', default=False, 
    help='big endianess (byteorder). little is default')

parser.add_argument('--byteorder', '--endian', '-e', type=str, default='little', 
        choices=['big', 'little'], help='endianess, i.e. byteorder')

parser.add_argument('--mirror', '-m', action='store_true', default=False, 
    help='mirror (reverse) bits per word. i.e. MSB --> LSB. \
            Not same as changed endianess')

'''
parser.add_argument('--verbose', '-v', default=0, action='count',
    help='Verbose output')
'''

def ceilmul(x, n):
    ''' round up to closest multiple of n '''
    r = x % n
    return x if r == 0 else (x + n - r)

def strsplitnth(s, n):
    ''' split string every n:th character '''
    return [s[i:i+n] for i in range(0, len(s), n)]


def revbytebits(b):
    b = ((b & 0xF0) >> 4) | ((b & 0x0F) << 4)
    b = ((b & 0xCC) >> 2) | ((b & 0x33) << 2)
    b = ((b & 0xAA) >> 1) | ((b & 0x55) << 1)
    return b

def convertword(v, nbytes, bigend=False, mirror=False):
    #order = 'little' if bigend else 'big' 
    ba = v.to_bytes(nbytes, byteorder=sys.byteorder)
    if mirror:
        ba = [revbytebits(b) for b in ba]
        ba = reversed(ba)

    order = 'big' if bigend else 'little' 
    return int.from_bytes(ba, byteorder=order)


def main():
    args = parser.parse_args()
    vmax = max(args.value)
    nbitsrequired = vmax.bit_length() + 1
    nbits = max(8, args.nbits, nbitsrequired)
    nbits = ceilmul(nbits, 4)

    nbytes = max(1, int(nbits / 8.0))
    nhexdig = nbytes * 2

    # bit postion header 
    rev4 = reversed(range(0, nbits, 4))
    nibidxs = ['{0: 4d} '.format(n) for n in rev4]
    print(''.join(nibidxs))

    for v in args.value:
        v = convertword(v, nbytes, args.bigend, args.mirror)
        s = '{:0{}b}'.format(v, nbits)
        nibs = strsplitnth(s, 4)
        hexdec = '  (0x{:0{}X}, {: >8})'.format(v, nhexdig * 2, v)
        print(' '.join(nibs), hexdec)

main()
