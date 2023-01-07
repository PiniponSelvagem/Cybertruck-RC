"""
Constains relevant constants, separated by class.
"""

from micropython import const

class AXPCommands:
    # Power off
    POWER_OFF_BATT_CHGLED_CTRL     = const(0x32)
    POWER_OFF_BATT_CHGLED_CTRL_OFF = const(0b1000_0000)

    # Temperature of AXP controller
    ADC_INTERNAL_TEMP_H            = const(0x5e)
    ADC_INTERNAL_TEMP_L            = const(0x5f)

    # Battery voltage
    ADC_BATT_VOLTAGE_H             = const(0x78)
    ADC_BATT_VOLTAGE_L             = const(0x79)