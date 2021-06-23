import RPi.GPIO as gpio
import time 


fan_pin = 14
gpio.setmode(gpio.BCM)
gpio.setup(fan_pin, gpio.OUT)

p = gpio.PWM(fan_pin, 100)
p.start(0)
duty = input("Please input number of PWM duty, from 0~100:")

try:
    while True:
        p.ChangeDutyCycle(int(duty))
        time.sleep(0.02)
except KeyboardInterrupt:
    p.stop()
    gpio.cleanup()

