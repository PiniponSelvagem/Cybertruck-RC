"""
Driver for the AXP192 power management unit.
"""

from lib.const import AXPCommands as CMD

class AXP192:
    """
    Battery graph taken from: Well 18650 3.7V 2200mAh 000180
    """
    _vbat = [
        2.9821, # 0
        3.1097, 3.1966, 3.2626, 3.3495, 3.3891, # 5
        3.4144, 3.4265, 3.4507, 3.4595, 3.4727, # 10
        3.4815, 3.4848, 3.4925, 3.4969, 3.5046, # 15
        3.5101, 3.5244, 3.5398, 3.5475, 3.5607, # 20
        3.5706, 3.5926, 3.6003, 3.6201, 3.6256, # 25
        3.6432, 3.6553, 3.6685, 3.6861, 3.6938, # 30
        3.7081, 3.7147, 3.7345, 3.7400, 3.7499, # 35
        3.7554, 3.7609, 3.7642, 3.7675, 3.7675, # 40
        3.7741, 3.7796, 3.7818, 3.7873, 3.7917, # 45
        3.7994, 3.8038, 3.8060, 3.8093, 3.8115, # 50
        3.8159, 3.8203, 3.8236, 3.8247, 3.8258, # 55
        3.8269, 3.8302, 3.8313, 3.8324, 3.8335, # 60
        3.8357, 3.8412, 3.8478, 3.8588, 3.8654, # 65
        3.8830, 3.8907, 3.9028, 3.9072, 3.9193, # 70
        3.9259, 3.9303, 3.9479, 3.9512, 3.9611, # 75
        3.9644, 3.9721, 3.9754, 3.9765, 3.9809, # 80
        3.9831, 3.9853, 3.9886, 3.9897, 3.9919, # 85
        3.9930, 3.9952, 3.9963, 3.9963, 3.9985, # 90
        3.9996, 4.0029, 4.0040, 4.0062, 4.0150, # 95
        4.0205, 4.0249, 4.0359, 4.0403, 4.0491  # 100
    ]

    """
    Power management information: AXP192
    """
    address = 0x34    # AXP192 i2c device address

    def __init__(self, i2c):
        self.i2c = i2c
        self.buf = bytearray(1)

    def read(self, regaddr):
        self.i2c.readfrom_mem_into(self.address, regaddr, self.buf)
        return self.buf[0]

    def write(self, regaddr, val):
        self.buf[0] = val
        self.i2c.writeto_mem(self.address, regaddr, self.buf)

    def batt_voltage(self):
        val = self.read(CMD.ADC_BATT_VOLTAGE_H) << 4
        val |= self.read(CMD.ADC_BATT_VOLTAGE_L)
        return val * 1.1 / 1000  # 1.1mV per LSB

    def batt_percentage(self):
        idx = 0
        vbat_curr = self.batt_voltage()
        for vbat in self._vbat:
            if vbat >= vbat_curr:
                return idx
            idx += 1
        return 100

    def internal_temp(self):
        val = self.read(CMD.ADC_INTERNAL_TEMP_H) << 4
        val |= self.read(CMD.ADC_INTERNAL_TEMP_L)
        return val * 0.1 - 144.7  # 0.1C per LSB, offset 144.7C

    def power_off(self):
        val = self.read(CMD.POWER_OFF_BATT_CHGLED_CTRL)
        val |= CMD.POWER_OFF_BATT_CHGLED_CTRL_OFF
        self.write(CMD.POWER_OFF_BATT_CHGLED_CTRL, val)
