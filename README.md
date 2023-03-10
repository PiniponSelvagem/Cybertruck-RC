# Cybertruck-RC
Cybertruck bluetooth radio controlled, project for the class DI3D (Design and 3d Printing) at ISEL, Instituto Superior de Engenharia de Lisboa.

This project contains the 3D model, the micro controller source code and the Android application source code.

## Features
It dances!
- Tesla Model X light show: https://www.youtube.com/watch?v=nrMW4mIjMkw
- Knight Rider light show: https://www.youtube.com/watch?v=KawXGOTbI-Q

Light modes:
- Blinkers, left, right and hazards
- Low beam
- Hight beam
- Brake

Oh, almost forgot... it drives.
- Foward / Backward
- Precision turning
- demo: https://www.youtube.com/watch?v=zXTYGtbgDoM

<br>

![Cybertruck RC](https://raw.githubusercontent.com/PiniponSelvagem/Cybertruck-RC/main/photos/YT_xmas_picture_below-2mb.jpg)

# 3D model
Created using OpenScad 2021.01, based of Tesla Cybertruck.<br>
The main file is **cybertruck.scad**, located at **3d_model** folder.<br>
It used PolyGear by Dario Pellegrini, https://github.com/dpellegr/PolyGear, for the back servo / motor to drive both wheels at same time.

# Microcontroller
The Cybertruck is controlled by a TTGO T-Beam v1.1 via Bluetooth.<br>
The TTGO T-Beam is running micropython, that can be found at https://github.com/nunomcruz/pycom-micropython-sigfox, ported by Nuno Cruz.
It is able to control 10 LEDs independently, each LED has its own dedicated PIN, and can control 2 servos.

Known bugs:
- servos drain battery when powered off, maybe a configuration within AXP192 can fix?

---
## Servos
The servos used are from Turnigy, TGY-R5180MG since they were the ones i had around. They are 180 degree servos, but since they dont have a stopper, one of them could be used has a motor without any hardware modification. The trick was the give him 2 specific invalid duty cycles, to trick him to run around. Very small duty cycle makes the servor spin around forward, while larger duty cycle makes it go backwards. Note that the backward movement gets a bit messed up (the servo jigles a bit at each 360 degree rotation), but with a duty cycle large enough it will run slow making it almost unnoticeable.

A continuous rotation servo can be used, but some adjustments will be required, such as:
- edit the file **servos.py** located at **/microcontroller/python/cybertruck**, by making the necessary adjustments to support it at the class **Motor**

PINs used:
- Pin 25 for direction servo
- Pin 2 for motor servo

---
## LEDs
5 white, 5 red with 220ohm resistors each.<br>
Due to board PINs limitation, the UART and I2C cannot be used while the LEDs are configured... but they actually can with a small work around.<br>
UART can be used to get a USB terminal, by during boot checking if the user is pressing the middle button of the TTGO. This will enter in a "debug" mode, by not configuring the UART PINs as output for the LEDs. It also looks cool while transfering data.<br>
I2C is used to keep track of the battery level, every minute the 2 LEDs at PINs 21 and 22 get their configuration reset to I2C, the percentage is calculated and then the PINs are set back to output. Barelly noticable while normal operation of the LEDs, unless you know exactly what to look for.

Pins used: (counting while looking from the front, and from the passenger side to the driver side)<br>
Head lights:
- Pin 01 - Headlight left
- Pin 03 - Headlight left middle
- Pin 23 - Headlight middle
- Pin 04 - Headlight right middle
- Pin 00 - Headlight right

Tail lights:
- Pin 15 - Taillight left
- Pin 14 - Taillight left middle
- Pin 13 - Taillight middle
- Pin 22 - Taillight right middle
- Pin 21 - Taillight right

# Android Application
Android application targeted for Android 5.1 or above.

**Currently the TTGO Bluetooth mac address is hardcoded, this should get fixed in a later version with a nearby bluetooth device list.**

Full control of the Cybertruck, with the added spirit of the cyber / neon colored app theme.

Known bugs:
- Hardcodded TTGO bluetooth mac address.
- If the hazards button is the first on to be pressed, sometimes it can lock other dashboard buttons interactions until app restart.
- Light configuration can mess up sometimes. Rare occurance, and until fix found a simple app restart can fix it.
- When dancing, if around 5 or more light configurations of 100ms delay get send to the TTGO, the microcontroller buffers can get full and the light configuration will be skipped. This is down to the developer to be carefull when creating dances. It is not recommented to send light configurations with less than 100ms delay, since they can / will be lost.