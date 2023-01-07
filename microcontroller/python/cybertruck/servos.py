from lib.devices.servo import Servo

class Wheel:
    def __init__(self, angleRange):
        """
        angleRange  -> max angle range to turn to one of the sides, will mirror to the other side
        """
        self.servo = Servo('G25', 0)
        self.minAngle = 90 - angleRange
        self.maxAngle = 90 + angleRange
        self.servo.sync()

    def setAngle(self, angle):
        if angle < 90:
            angle = max(angle, self.minAngle)
        elif angle > 90:
            angle = min(angle, self.maxAngle)
        self.servo.setAngle(angle)



class Motor:
    def __init__(self):
        self.servo = Servo('G2', 1, min_duty=0.01, max_duty=0.99)
    
    def setSpeed(self, speed):
        if (speed == 0x01):
            self.servo.setDuty(0.01)
        elif (speed == 0xff):
            self.servo.setDuty(0.99)
        else:
            self.servo.setDuty(0)