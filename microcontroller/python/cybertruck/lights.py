from machine import Pin
from time import sleep_ms

class Lights:
    def __init__(self, usbDebug):
        self.usbDebug = usbDebug
        if (self.usbDebug == False):
            self.LH_1 = Pin('G1', mode=Pin.OUT)
            self.LH_2 = Pin('G3', mode=Pin.OUT)
        self.LH_3 = Pin('G23', mode=Pin.OUT)
        self.LH_4 = Pin('G4',  mode=Pin.OUT)
        self.LH_5 = Pin('G0',  mode=Pin.OUT)
        
        self.LT_1 = Pin('G15', mode=Pin.OUT)
        self.LT_2 = Pin('G14', mode=Pin.OUT)
        self.LT_3 = Pin('G13', mode=Pin.OUT)
        self.LT_4 = Pin('G22', mode=Pin.OUT)
        self.LT_5 = Pin('G21', mode=Pin.OUT)

        if (self.usbDebug == False):
            self.LH_1(0)
            self.LH_2(0)
        self.LH_3(0)
        self.LH_4(0)
        self.LH_5(0)

        self.LT_1(0)
        self.LT_2(0)
        self.LT_3(0)

        # leds at i2c
        self.LT_4_status = 0
        self.LT_5_status = 0
        self.LT_4(self.LT_4_status)
        self.LT_5(self.LT_5_status)


    def reEnable_leds_at_i2c(self):
        self.LT_4 = Pin('G22', mode=Pin.OUT)
        self.LT_5 = Pin('G21', mode=Pin.OUT)
        self.LT_4(self.LT_4_status)
        self.LT_5(self.LT_5_status)


    def toggleLH_1(self):
        if (self.usbDebug == False): self.LH_1.toggle()
    def toggleLH_2(self):
        if (self.usbDebug == False): self.LH_2.toggle()
    def toggleLH_3(self):    self.LH_3.toggle()
    def toggleLH_4(self):    self.LH_4.toggle()
    def toggleLH_5(self):    self.LH_5.toggle()

    def toggleLT_1(self):    self.LT_1.toggle()
    def toggleLT_2(self):    self.LT_2.toggle()
    def toggleLT_3(self):    self.LT_3.toggle()
    def toggleLT_4(self):
        self.LT_4_status = ~self.LT_4_status
        self.LT_4.toggle()
    def toggleLT_5(self):
        self.LT_5_status = ~self.LT_5_status
        self.LT_5.toggle()


    def setLH_1(self, state):
        if (self.usbDebug == False): self.LH_1(state)
    def setLH_2(self, state):
        if (self.usbDebug == False): self.LH_2(state)
    def setLH_3(self, state):    self.LH_3(state)
    def setLH_4(self, state):    self.LH_4(state)
    def setLH_5(self, state):    self.LH_5(state)

    def setLT_1(self, state):    self.LT_1(state)
    def setLT_2(self, state):    self.LT_2(state)
    def setLT_3(self, state):    self.LT_3(state)
    def setLT_4(self, state):
        self.LT_4_status = state
        self.LT_4(self.LT_4_status)
    def setLT_5(self, state):
        self.LT_5_status = state
        self.LT_5(self.LT_5_status)


    def allOn(self):
        self.setLH_1(1)
        self.setLH_2(1)
        self.setLH_3(1)
        self.setLH_4(1)
        self.setLH_5(1)

        self.setLT_1(1)
        self.setLT_2(1)
        self.setLT_3(1)
        self.setLT_4(1)
        self.setLT_5(1)
    def allOff(self):
        self.setLH_1(0)
        self.setLH_2(0)
        self.setLH_3(0)
        self.setLH_4(0)
        self.setLH_5(0)

        self.setLT_1(0)
        self.setLT_2(0)
        self.setLT_3(0)
        self.setLT_4(0)
        self.setLT_5(0)

    def effectConnected(self):
        self.allOff()
        self.setLH_1(1)
        self.setLH_5(1)
        self.setLT_1(1)
        self.setLT_5(1)
        sleep_ms(200)
        self.allOff()

    def effectDisconnected(self):
        self.allOff()
        self.setLH_1(1)
        self.setLH_5(1)
        self.setLT_1(1)
        self.setLT_5(1)
        sleep_ms(1000)
        self.allOff()