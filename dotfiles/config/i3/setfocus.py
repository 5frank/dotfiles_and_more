
#!/usr/bin/env python3
import i3ipc

def main():
    i3 = i3ipc.Connection()
    ws = i3.get_tree().find_focused().workspace()
    layout = ws.descendents()[0].layout
    print(layout)
    exit(0)

    if layout == 'tabbed':
        i3.command('layout default')
    else:
        i3.command('layout tabbed')

main()
