#!/usr/bin/env python3 
import argparse
from sys import stderr
from struct import pack as struct_pack

# IEEE754 floating point/ '<'=little, '>'=big
STRUCT_FMT_FP = {
    16: '>e',
    32: '>f',
    64: '>d'
}

def print_err(*args, **kwargs):
    print('E:', *args, file=stderr, **kwargs)

def revbytebits(b):
    ''' reverse bits in a single byte '''
    b = ((b & 0xF0) >> 4) | ((b & 0x0F) << 4)
    b = ((b & 0xCC) >> 2) | ((b & 0x33) << 2)
    b = ((b & 0xAA) >> 1) | ((b & 0x55) << 1)
    return b

def header(nbits):
    rev4 = reversed(range(0, nbits, 4))
    nibidxs = ['{0: 4d} '.format(n) for n in rev4]
    s = ''.join(nibidxs)
    nbytes = nbits // 8
    s += "| HEX".ljust(nbytes * 2 + 3)
    s += "| DEC"
    return s

class Word(object):
    ''' "Word" as in series of bytes and bits '''

    def __init__(self, sval, nbits=32, base=0):

        # always use big endian as bits displayed w MSB first, 
        # i.e. N, N-1, ... 2, 1, 0. no need to reverse later
        self.nbytes = int(nbits / 8)
        if '.' in sval:
            val = float(sval)
            if nbits not in STRUCT_FMT_FP:
                print_err('wordsize', nbits, 
                        'can not be used with floating point')
                exit(1)

            self.ba = struct_pack(STRUCT_FMT_FP[nbits], val)
        else:
            val = int(sval, base)
            self.ba = val.to_bytes(self.nbytes,
                    signed = val < 0, 
                    byteorder='big')

        self.sval = sval
        self.val = val

    def revbytes(self):
        self.ba.reverse()

    def revbits(self, bytewise=False):
        src = reversed(self.ba) if bytewise else self.ba
        self.ba = bytearray([revbytebits(b) for b in src])

    def invert(self):
        self.ba = bytearray([(~b & 0xFF) for b in self.ba])

    def nibstr(self):
        bNibs = lambda x : '{:04b} {:04b}'.format((x >> 4) & 0xf, x & 0xf)
        a = [bNibs(b) for b in self.ba]
        return ' '.join(a)

    def hexstr(self):
        a = ['{:02X}'.format(b) for b in self.ba]
        #return '0x' + ''.join(a)
        return ''.join(a)

    def __str__(self):
        return '{} | {} | {}'.format(self.nibstr(), self.hexstr(), self.val)

parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
        description='print pretty bits with extras.')

parser.add_argument('values', metavar='VAL', nargs='+',
        help='One or more values in hex, decimal or floating point \
        format.  Formats can be mixed.  \
        floating point interpreted as IEEE754 16, 32 or 64 bit floats \
        depending on wordsize')

parser.add_argument('--wordsize', '-w', metavar='N', type=int, default=32,
        choices=[8, 16, 24, 32, 64, 128], 
        help='Word size in bits and also number of bits per line. \
                must be a multiple of 8')

parser.add_argument('--hex', '-x', action='store_true', 
        help='All inputs interpreted as hexadecimal')

parser.add_argument('--invert', '-i', action='store_true', 
        help='invert bits')

parser.add_argument('--reverse', '-r', default=None, 
        choices=['word', 'byte','w','W', 'b', 'B'], 
        help='Reverse bit order byte- or word-wise.')


def main():
    args = parser.parse_args()

    args.wordsize = int(args.wordsize)
    if args.reverse:
        c = args.reverse[0].lower()
        revbitsbytewise = True if c == 'w' else False
    else:
        revbitsbytewise = None

    base = 16 if args.hex else 0

    words = [None] * len(args.values)
    for i, s in enumerate(args.values):
        w = Word(s, nbits=args.wordsize, base=base)

        if revbitsbytewise is not None:
            w.revbits(bytewise=revbitsbytewise)

        if args.invert:
            w.invert()

        words[i] = w

    print(header(args.wordsize))
    for w in words:
        print(w)
    exit(0)


main()
