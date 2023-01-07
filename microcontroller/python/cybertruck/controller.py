from time import sleep
import _thread as Thread
from lib.devices.ble import BLE

from cybertruck.servos import Wheel
from cybertruck.servos import Motor
from cybertruck.lights import Lights
from cybertruck.battery import Battery

class Controller:
    def __init__(self, battery: Battery, wheel: Wheel, motor: Motor, lights: Lights):
        self.battery = battery
        self.wheel   = wheel
        self.motor   = motor
        self.lights  = lights

    def start(self):
        Thread.start_new_thread(self.bleAdvertiserTask, ())

    def controllerReset(self):
        self.wheel.setAngle(90)
        self.motor.setSpeed(0)

    def conn_cb (self, bt_o):
        events = bt_o.events()
        if  events & BLE.TG_CLIENT_CONNECTED:
            self.controllerReset()
            self.lights.effectConnected()
        elif events & BLE.TG_CLIENT_DISCONNECTED:
            self.controllerReset()
            self.lights.effectDisconnected()

    """
    def lights_cb_handler(self, chr, data):
        events, value = data
        if events & BLE.TG_CHAR_WRITE_EVENT:
            try:
                self.lights.setLH_1(value[0] & 0x01)
                self.lights.setLH_2(value[0] & 0x02)
                self.lights.setLH_3(value[0] & 0x04)
                self.lights.setLH_4(value[0] & 0x08)
                self.lights.setLH_5(value[0] & 0x10)
                
                self.lights.setLT_1(value[1] & 0x01)
                self.lights.setLT_2(value[1] & 0x02)
                self.lights.setLT_3(value[1] & 0x04)
                self.lights.setLT_4(value[1] & 0x08)
                self.lights.setLT_5(value[1] & 0x10)
            except:
                pass

    def control_cb_handler(self, chr, data):
        events, value = data
        if events & BLE.TG_CHAR_WRITE_EVENT:
            try:
                self.wheel.setAngle(value[0])
                self.motor.setSpeed(value[1])
            except:
                pass
    """

    def combined_cb_handler(self, chr, data):
        events, value = data
        if events & BLE.TG_CHAR_WRITE_EVENT:
            try:
                self.wheel.setAngle(value[0])
                self.motor.setSpeed(value[1])

                self.lights.setLH_1(value[2] & 0x01)
                self.lights.setLH_2(value[2] & 0x02)
                self.lights.setLH_3(value[2] & 0x04)
                self.lights.setLH_4(value[2] & 0x08)
                self.lights.setLH_5(value[2] & 0x10)
                
                self.lights.setLT_1(value[3] & 0x01)
                self.lights.setLT_2(value[3] & 0x02)
                self.lights.setLT_3(value[3] & 0x04)
                self.lights.setLT_4(value[3] & 0x08)
                self.lights.setLT_5(value[3] & 0x10)
            except:
                pass


    def bleAdvertiserTask(self):
        self.controllerReset()

        ble = BLE("Cybertruck")
        ble.createAdvertiser(
            "70696e696379626572747275636b0000",    #'pinicybertruck' and last 4 digits are free to use
            self.conn_cb,
            BLE.TG_CLIENT_CONNECTED | BLE.TG_CLIENT_DISCONNECTED
        )
        chrBattery = ble.createService(
            "70696e696379626572747275636b0100",
            "70696e696379626572747275636b0101",
            None,   # battery read
            BLE.TG_CHAR_READ_EVENT
        )
        ble.createService(
            "70696e696379626572747275636b0200",
            "70696e696379626572747275636b0201",
            self.combined_cb_handler,
            BLE.TG_CHAR_WRITE_EVENT
        )
        """
        ble.createService(
            "70696e696379626572747275636b0300",
            "70696e696379626572747275636b0301",
            self.lights_cb_handler,
            BLE.TG_CHAR_WRITE_EVENT
        )
        ble.createService(
            "70696e696379626572747275636b0400",
            "70696e696379626572747275636b0401",
            self.control_cb_handler,
            BLE.TG_CHAR_WRITE_EVENT
        )
        """

        while(True):
            value = self.battery.read()
            self.lights.reEnable_leds_at_i2c()
            try:
                chrBattery.value(value)
            except:
                pass # ignore exception: OSError: Error while sending BLE indication/notification
            sleep(60)
