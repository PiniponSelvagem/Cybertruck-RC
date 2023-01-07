from machine import PWM
from time import sleep_ms

# originally by Radomir Dopieralski http://sheep.art.pl
# from https://bitbucket.org/thesheep/micropython-servo
#
# modified by: PiniponSelvagem
# - duty cycle instead of signal length, uses less calculations
# - removed if radians
# - renamed functions write to set

class Servo:
    """
    A simple class for controlling hobby servos.
    Args:
        pin (machine.Pin): The pin where servo is connected. Must support PWM.
        freq (int): The frequency of the signal, in hertz.
        min_duty (float [0..1]): The minimum duty cycle supported by the servo.
        max_duty (float [0..1]): The maximum duty cycle supported by the servo.
        angle (int): The angle between the minimum and maximum positions.
    """
    def __init__(self, pin, channel, freq=60, min_duty=0.06, max_duty=0.12, angle=180):
        self.min_duty = min_duty
        self.max_duty = max_duty
        self.duty = 0
        self.freq = freq
        self.angle = angle
        self.pin = pin
        self.channel = channel
        self.pwm = PWM(channel, frequency=freq)
        self.pwm.channel(self.channel, pin=self.pin, duty_cycle=0)

    def sync(self):
        for i in range(0, 10, 1):
            self.setAngle(90)
            sleep_ms(50)
            self.setDuty(0)
            sleep_ms(50)

    def setDuty(self, duty):
        if duty == 0:
            self.pwm.channel(self.channel, pin=self.pin, duty_cycle=0)
            return
        duty = min(self.max_duty, max(self.min_duty, duty))
        self.pwm.channel(self.channel, pin=self.pin, duty_cycle=duty)

    def setAngle(self, degrees):
        degrees = degrees % 360
        total_range = self.max_duty - self.min_duty
        duty = self.min_duty + total_range * degrees / self.angle
        self.setDuty(duty)