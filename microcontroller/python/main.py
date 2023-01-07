print("--- main.py ---")


from machine import Pin, I2C
from time import sleep_ms
import config

print("Button setup")
from lib.devices.button import Button
button = Button()

print("WiFi setup")
from lib.devices.wifi import WiFi
wifi = WiFi()
if wifi.connect(config.WIFI_SSID, config.WIFI_PASS):
    print("WiFi: "+config.WIFI_SSID)
else:
    print("WiFi: "+config.WIFI_SSID+", NOT FOUND")



def checkDebugUSB():
    """
    Since LEDs in PINs 1 and 3, are also used by UART for serial USB connection,
    During this stage, if the button is pressed, it will inform the lights to not
    use them.
    """
    enableTerminalUSB = False
    led = Pin('G4',  mode=Pin.OUT)
    for i in range(20):
        led.toggle()
        button.pullEvents()
        enableTerminalUSB = button.isPressed(0)
        if enableTerminalUSB == True:
            led(1)
            break
        sleep_ms(100)
    return enableTerminalUSB

usbDebug = checkDebugUSB()



#sleep_ms(30000)

from cybertruck.battery import Battery
battery = Battery()

from cybertruck.servos import Wheel, Motor
wheel = Wheel(20)
motor = Motor()

from cybertruck.lights import Lights
lights = Lights(usbDebug)


from cybertruck.controller import Controller
cybertruck = Controller(battery, wheel, motor, lights)
cybertruck.start()
