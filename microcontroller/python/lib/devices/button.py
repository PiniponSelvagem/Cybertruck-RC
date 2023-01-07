"""
Adaptation of library done by PiniponSelvagem for LPC1769.
Supports up to 16 buttons.
"""

from machine import Pin

class Button:
    __buttons = [
        Pin('G38', mode=Pin.IN)     # ID: 0
    ]   # add buttons up to 16 total (0-15 ID)

    """
    btnsLastState
        1st bit -> 1st button active state (0 -> inactive, 1 -> active)
        2nd bit -> 1st button transition state (0 -> is repeating last state, 1 -> button transitioned to new state)
        ...
        31th bit -> 16th button active state
        32th bit -> 16th button transition state
        
        example: (pressing, keeping pressed and then releasing)
            00 -> no button press
            11 -> button press start (trasition)
            01 -> button repeating
            01 -> button repeating
            10 -> button released (trasition)
            00 -> no button press
    """
    btnsLastState = 0  

    """
        Button mask used to get 1 bit of each button.
        Depending if shift is used or not, it can be used to get only the pressed states or the transition states for all buttons.
        Binary representation visualization:
        > 0101 0101 0101 0101 0101 0101 0101 0101
    """
    BTNS_MASK_ACTIVE = 0x55555555
    BTN_MASK_SIZE = 2

    BTN_PRESSED_MASK = 0x1  # DO NOT change these defines, since pullEvents and updateEvent algorithm are dependent of these values.
    BTN_CHANGED_MASK = 0x2  # DO NOT change these defines, since pullEvents and updateEvent algorithm are dependent of these values.


    def __btn_is_pressed(self, id): return (self.btnsLastState & (self.BTN_PRESSED_MASK << (id * self.BTN_MASK_SIZE)))
    def __btn_is_changed(self, id): return (self.btnsLastState & (self.BTN_CHANGED_MASK << (id * self.BTN_MASK_SIZE)))

    # Checks for button state changes and their active state, and returns it as a mask.
    def __updateEvent(self, btn, id):
        pinsState = ~((int(btn())) << id * self.BTN_MASK_SIZE)
        pinsState &= (0x1 << (self.BTN_MASK_SIZE * id));    # 0x1 -> to make & with the current state.
        return pinsState
    # END -> __updateEvent #

    def pullEvents(self):
        btnsActive = 0
        i = 0
        for btn in self.__buttons:
            btnsActive |= self.__updateEvent(btn, i)
            i+= 1
        state = btnsActive | ((btnsActive ^ (self.BTNS_MASK_ACTIVE & self.btnsLastState)) << 1)     # 1 -> shift left to place transitions states
        self.btnsLastState = state
    # END -> pullEvents #

    def getSnapshot(self): return self.buttonLastState

    def isPressed(self, id):          return self.__btn_is_pressed(id)
    def isChanged(self, id):          return self.__btn_is_changed(id)
    def isPressedRepeating(self, id): return self.__btn_is_pressed(id) and ~self.__btn_is_changed(id)
    def isSinglePressed(self, id):    return self.__btn_is_pressed(id) and self.__btn_is_changed(id)
    def isSingleReleased(self, id):   return ~self.__btn_is_pressed(id) and self.__btn_is_changed(id)
    def isAnyPressed(self):           return self.btnsLastState and self.BTNS_MASK_ACTIVE

