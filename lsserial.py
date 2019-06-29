#!/usr/bin/env python3 

from serial.tools.list_ports import comports
from glob import glob
from os import path

from collections import OrderedDict
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

    device = path.realpath(device)# expand symlink. needed?
    basename = path.basename(device)

    matches = glob('/sys/bus/usb/devices/*/{}'.format(basename))
    if len(matches) < 1:
        return '-'

    assert(len(matches) == 1) # not sure what to do with this

    parent = path.abspath(path.join(matches[0], '..'))
    busid = path.basename(parent)
    return busid

def busid_to_vidpid(busid):
    ''' return true if usb bus ID matches VID and PID '''
    if busid is None:
        return (None, None)

    if busid.startswith('usb'): # USB controllers or root hub
        return (None, None)

    if ':' in busid: # strip ":<config>.<interface>"
        busid = busid.split(':')[0] # from "3-1:1.2" to "3-1"

    def readid(_basepath, _idfile):
        p = path.join(_basepath, _idfile)

        if not path.exists(p):
            return None
        with open(p) as f:
            idX = f.readline()
        return idX.strip()

    basepath = path.join('/sys/bus/usb/devices/', busid)

    vid = readid(basepath, 'idVendor')
    pid = readid(basepath, 'idProduct')
    return (vid, pid)

class SerialDeviceInfo(object):
    def __init__(self, devname, descr):
        self.devname = devname
        self.descr = descr
        self.busid = busid_from_device(devname)
        vid, pid = busid_to_vidpid(self.busid)
        self.usbvid = vid
        self.usbpid = pid

def deviceInfo(devname, descr):
    d = OrderedDict()
    d['devname']= devname
    d['descr']= descr
    busid = busid_from_device(devname)
    vid, pid = busid_to_vidpid(busid)
    d['busid']= busid
    d['usb_vid']= vid
    d['usb_pid']= pid

def columnwidth(rows, i):
    return max([len(row[i]) for row in rows])

def printaligned(rows):

    ncols = len(rows[0])
    if ncols < 1:
        return

    if ncols == 1:
        for row in rows:
            print(row[0]) 
        return

    colfmt = ''
    for i in range(0, ncols - 1):
        width = columnwidth(rows, i)
        colfmt += '{: <' + str(width) + '}  ' 
    colfmt += '{}'

    for row in rows:
         #print('{: <16} {: <16} {}'.format(*row))
         line = colfmt.format(*row)
         print(line)


def main():
    parser = argparse.ArgumentParser(description='List serial ports',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('--usb', '-u', action='store_true', default=False, 
	help='show and sort by usb bus id. (GNU/Linux only)')

    '''

    parser.add_argument('--all', '-a', action='store_true', default=False, 
        help='include extra info, serial ports not binded to a device etc')



    parser.add_argument('--verbose', '-v', default=0, action='count',
        help='Verbose output')
    '''
    parser.add_argument('--test', action='store_true', default=False)

    parser.add_argument('--usb-pid', type=str, action='append', default=[], 
            help='Match USB product ID(s). Hex format')

    parser.add_argument('--usb-vid', type=str, action='append', default=[], 
            help='Match USB vendor ID(s). Hex format')

    args = parser.parse_args()
    if args.test:
        ports = [
            ['/dev/ttyUSB0', 'Quad RS232-HS'], 
            ['/dev/ttyUSB1', 'Quad RS232-HS'], 
            ['/dev/ttyUSB2', 'Quad RS232-HS'], 
            ['/dev/ttyUSB3', 'Quad RS232-HS']]
    else: 
        ports = comports()

    #rows = [] 
    sdis = []
    for port in ports:
        sdi = deviceInfo(devname=port[0], descr=port[1]) 
        sdis.append(sdi)

        # device = port[0]
        # descr = port[1]
        # cells = []
        # if args.usb:
            # busid = busid_from_device(device) 
            # cells.append(busid)
        # cells.extend([device, descr])
        # rows.append(cells)

    if len(sdis) == 0:
        return 0


    #sdis = sorted(sdis)
    print(sdis)
    #printaligned(sdis)


if __name__ == '__main__':
    main()
