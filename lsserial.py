#!/usr/bin/env python3 

from serial.tools.list_ports import comports
from glob import glob
from os import path

import argparse
'''
major numbers:
 src: kernel.org/doc/Documentation/admin-guide/devices.txt

 188 char USB serial converters
 189 char USB serial converters - alternate devices<Paste>
  there are more...


useful commands:
    ls /sys/bus/usb-serial/devices/
    ls /sys/bus/serial/devices/

'''

def busid_from_device(device):
    ''' get USB bus id from a device (ex. /dev/ttyUSB) '''

    device = path.realpath(device)# expand symlink
    basename = path.basename(device)

    matches = glob('/sys/bus/usb/devices/*/{}'.format(basename))
    if len(matches) < 1:
        return '-'

    assert(len(matches) == 1) # not sure what to do with this

    parent = path.abspath(path.join(matches[0], '..'))
    busid = path.basename(parent)
    return busid

def usb_tree(devices):
    
    path = '/sys/bus/usb/devices/*/{}'.format(basename)
    matches = glob(path)
    parent = path.abspath(path.join(path, '..'))
    busid = path.basename(parent)



def main():
    '''
    parser = argparse.ArgumentParser(description='List serial ports',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('--all', '-a', action='store_true', default=False, 
        help='include extra info, serial ports not binded to a device etc')

    parser.add_argument('--tree', '-t', action='store_true', default=False, 
	help='try list as tree. mostly relevant for usb-serial devices')

    parser.add_argument('--verbose', '-v', default=0, action='count',
        help='Verbose output')
    '''

    args = parser.parse_args()
    cols = [] 
    for port in comports(): 
        device = port[0]
        descr = port[1]
        busid = busid_from_device(device)
        cols.append([busid, device, descr])
        cols.append([busid, device, descr])
	
       
    for row in sorted(cols):
         print('{: <16} {: <16} {}'.format(*row))
       

if __name__ == '__main__':
    main()
