from math import exp, log
from sys import argv

'''
 Give your file to root
Soooo we just give it to the root user

$ sudo chown root:root brightness_control

and

$ sudo chmod 0711 brightness_control
'''

def np_test():
    # https://en.wikipedia.org/wiki/Logistic_function
    import numpy as np
    import matplotlib.pyplot as plt

    # /sys/class/backlight/intel_backlight/max_brightness
    # L = the curve's maximum value. i.e. brightness_max
    L = 4000.0
    # k = the logistic growth rate or steepness of the curve
    # k = 0 --> linear
    k = 0.1 
    # x = input in percent
    x = np.linspace(0.0, 100.0, 100)
    # y output in range 0 to 
    y = L / (1 + np.exp(-k * (x - 50)))

    plt.plot(y)
    #plt.ylabel('')
    plt.show()


'''
https://github.com/haikarainen/light
Note: you must be in the video group. `sudo usermod -a -G video $USER`
'''
USE_LIGHT_CMD = True

import subprocess

def sys_class_get(prop):
    path = '/sys/class/backlight/intel_backlight/{}'.format(prop)
    with open(path) as f:
        val = f.readline()
    return float(val.strip())

def sys_class_set(prop, val):
    path = '/sys/class/backlight/intel_backlight/{}'.format(prop)
    with open(path, 'w') as f:
        f.write(str(int(val)))


def get_max_brightness():
    return sys_class_get('max_brightness')

def get_brightness():
    return sys_class_get('brightness')

def set_brightness(val):
    global USE_LIGHT_CMD
    if USE_LIGHT_CMD:
        val = str(int(val))
        subprocess.run(['light', '-Sr', val])
    else:
    	sys_class_set('brightness', val)

def clamp(x, min_, max_):
    if x < min_:
        return min_
    elif x > max_:
        return max_
    else:
        return x
    

def main():
    print(argv)
    if len(argv) <= 1:
        return
    # k = 0 --> linear
    k = 0.1 

    y_max = get_max_brightness()
    y_cur = get_brightness() 
    print(y_cur, 'of', y_max)

    if y_cur >= y_max:
        x_cur = 100.0
    elif y_cur <= 0:
        x_cur = 0.0
    else:
        x_cur = -log(y_max / y_cur - 1.0) / k + 50.0

    print(x_cur, y_cur)

    step = 2 
    if argv[1] == 'up':
        x_new = x_cur + step
    elif argv[1] == 'down':
        x_new = x_cur - step
    else:
        raise ValueError('bad args. up|down')
        x_new = x_cur
        
    x_new = clamp(x_new, 0.0, 100.0) 

    
    y_new = y_max / (1.0 + exp(-k * (x_new - 50.0)))
    y_new = clamp(y_new, 2, y_max)

    #exp(-k * (x_new - 50))) = y_max / y_new - 1

    print(x_new, y_new)
    set_brightness(y_new)
    

    # exp(-k * (x - 50)) = L / y - 1
    


if __name__ == '__main__':
    main()

