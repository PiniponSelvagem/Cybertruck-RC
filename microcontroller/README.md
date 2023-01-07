# Cybertruck-RC
# Microcontroller
The Cybertruck is controlled by a TTGO T-Beam v1.1 via Bluetooth.<br>
The TTGO T-Beam is running micropython, that can be found at https://github.com/nunomcruz/pycom-micropython-sigfox, ported by Nuno Cruz.
It is able to control 10 LEDs independently, each LED has its own dedicated PIN, as well has control 2 servos.

---
## Servos
The servos used are from Turnigy, TGY-R5180MG since they were the ones i had around. They are 180 degree servos, but since they dont have a stopped, one of them could be used has a motor without any hardware intervention. The trick was the give him 2 specific invalid duty cycles, to trick him to run around. Very small duty cycle makes the servor spin around forward, while larger duty cycle makes it go backwards. Note that the backward movement gets a bit messed up (the servo jigles a bit at each 360 degree rotation), but with a duty cycle large enough it will run slow making it almost unnoticeable.

A continuous rotation servo can be used, but some adjustments will be required, such as:
- edit the file **servos.py** located at **/microcontroller/python/cybertruck**, by making the necessary adjustments to support it at the class **Motor**

PINs used:
- Pin 25 for direction servo
- Pin 2 for motor servo

---
## LEDs
5 white, 5 red with 220ohm resistors each.<br>
Due to board PINs limitation, the UART and I2C cannot be used while the LEDs are configured... but they actually can with a small work around.<br>
UART can be used to get a USB terminal, by during boot checking if the user is pressing the middle button of the TTGO and not letting those 2 Pins be configured as output for the LEDs. Also looks cool while transfering data.<br>
I2C is used to keep track of the battery level, every minute the 2 LEDs at PINs 21 and 22 get their configuration reset to I2C, the percentage is calculated and then the PINs are set back to output. Barelly noticable while normal operation of the LEDs unless you know exactly what to look for.

Pins used: (counting while looking from the front, and from the passenger side to the driver side)
- Pin 1 - Headlight left
- Pin 3 - Headlight left middle
- Pin 23 - Headlight middle
- Pin 4 - Headlight right middle
- Pin 0 - Headlight right
<br>
<br>
- Pin 15 - Taillight left
- Pin 14 - Taillight left middle
- Pin 13 - Taillight middle
- Pin 22 - Taillight right middle
- Pin 21 - Taillight right
