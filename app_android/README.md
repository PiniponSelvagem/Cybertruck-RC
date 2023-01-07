# Cybertruck-RC
# Android Application
Android application targeted for Android 5.1 or above.

**Currently the TTGO Bluetooth mac address is hardcoded, this should get fixed in a later version with a nearby bluetooth device list.**

Full control of the Cybertruck, with the added spirit of the cyber / neon colored app theme.

Known bugs:
- Hardcodded TTGO bluetooth mac address.
- If the hazards button is the first on to be pressed, sometimes it can lock other dashboard buttons interactions until app restart.
- Concurrency is not 100% safe, since it can happen to have conflicting light configurations, this is a rare occurance and a simple app restart can fix it.
- When dancing, if around 5 or more light configurations of 100ms delay get send to the TTGO, the microcontroller buffers can get full and the light configuration will be skipped. This is down to the developer to be carefull when creating dances. It is not recommented to send light configurations with less than 100ms delay, since they can / will be lost.