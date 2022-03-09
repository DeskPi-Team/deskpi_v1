####### Read me first!!! ######################## 
# Name: safe_shutdown.py
# Function:  Read `poweroff` signal from MCU and shutdown Raspberry Pi when the power button has been pressed twice.
# Require library: pyserial 
# Install pyserial library by using `pip3 install pyserial` (Python3.x) 
################################################# 
#!/usr/bin/python3
import serial
import time
import os


ser = serial.Serial('/dev/ttyUSB0', baudrate=9600, timeout=10)

while True:
    try:
        if ser.isOpen():
            data = ser.read(16).decode('utf-8')
            if 'poweroff' in data:
                print("System will be shutdown after 3 seconds!")
                for i in range(1, 4):
                    print(i)
                    time.sleep(1)
                os.system("sudo sync && sudo init 0")
    except KeyboardInterrupt:
        ser.close()
        break
        print("---End program---")
