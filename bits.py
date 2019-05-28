#!/usr/bin/env python3 
import argparse
import sys
from math import ceil, log

def _toint(x):
    return int(x, 0)

def eprint(*args, **kwargs):
    ''' error print '''
    print(*args, file=sys.stderr, **kwargs)

def vprint(*args, **kwargs):
    ''' verbose print '''
    if g_args.verbose >= 1:
        print(*args, file=sys.stdout, **kwargs)

parser = argparse.ArgumentParser(
        description='Pretty print bits. Like hexdump but for bits')

parser.add_argument('values', metavar='INTVAL', type=str, nargs='+',
    help='''One or more hex- or decimal integer values. Can be mixed format.''')

parser.add_argument('--wordsize', '-w', metavar='N', type=int, default=32,
    choices=[8, 12, 16, 24, 32, 48, 64, 128], 
    help='''Word size and number of bits per line. Will be overridden if
    passed value(s) do not fit''')
#and always rounded up to closest multiple of four, otherwise default to 32''')

parser.add_argument('--bigend', '-b', action='store_true', default=False, 
    help='big endianess (byteorder). little is default. confusing results')

parser.add_argument('--hex', '-x', action='store_true', default=False, 
    help='All inputs interpreted as hexadecimal')

parser.add_argument('--revbit', '-r', type=str, default='', 
     choices=['word', 'byte','w','W', 'b', 'B'], 
     help='''Reverse bit order byte- or word-wise. Not same as changed endianess''')


'''

parser.add_argument('--byteorder', '--endian', '-e', type=str, default='little', 
        choices=['big', 'little'], 
        help='endianess (eg. byteorder) of input and output.')
'''

parser.add_argument('--verbose', '-v', default=0, action='count',
    help='Verbose output (debug)')

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

def convertword(v, nbytes, bigend=False, revbit=''):
    #order = 'little' if bigend else 'big' 
    ba = v.to_bytes(nbytes, byteorder=sys.byteorder)

    if revbit.startswith('w'):
        ba = [revbytebits(b) for b in reversed(ba)]

    elif revbit.startswith('b'):
        ba = [revbytebits(b) for b in ba]

    order = 'big' if bigend else 'little' 
    return int.from_bytes(ba, byteorder=order)

def parsevalues(args):
    vals = [None] * len(args.values)
    base = 16 if args.hex else 0
    for i, s in enumerate(args.values):
        vals[i] = int(s, base)
    return vals
    
def main():
    args = parser.parse_args()
    values = parsevalues(args)

    nbitsrequired = max(values).bit_length() 
    nbits = max(8, args.wordsize, nbitsrequired)
    nbits = ceilmul(nbits, 4)

    nbytes = max(1, int((nbits + 4) / 8.0))
    nhexdig = nbytes * 2
    args.revbit = args.revbit.lower()

    if args.verbose:
        print(args)
        print('nbits: ', nbits, ' required: ', nbitsrequired)
        print('nbytes: ', nbytes)

    # bit postion header 
    rev4 = reversed(range(0, nbits, 4))
    nibidxs = ['{0: 4d} '.format(n) for n in rev4]
    print(''.join(nibidxs))

    for v in values:
        v = convertword(v, nbytes, args.bigend, args.revbit)
        s = '{:0{}b}'.format(v, nbits)
        nibs = strsplitnth(s, 4)
        hexdec = '  |0x{:0{}X}  {: >8}|'.format(v, nhexdig, v)
        print(' '.join(nibs), hexdec)

main()
