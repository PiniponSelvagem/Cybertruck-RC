from machine import I2C
from lib.devices.axp import AXP192

class Battery:
    def read(self):
        i2c = I2C(baudrate=400_000, pins=('G21','G22'))
        axp = AXP192(i2c)
        read = axp.batt_percentage()
        i2c.deinit()
        return read
