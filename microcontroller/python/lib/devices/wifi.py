"""
WiFi simplified driver wrapper.
"""

from network import WLAN
from time import sleep_ms

class WiFi():
    HOSTNAME = "TTGO T-Beam v1.1"

    def __init__(self):
        self.wlan = WLAN(mode=WLAN.STA)

    def connect(self, ssid, authetication):
        nets = self.wlan.scan()
        for net in nets:
            if net.ssid == ssid:
                self.wlan.connect(net.ssid, auth=(net.sec, authetication), timeout=5000)
                while not self.wlan.isconnected():
                    sleep_ms(100)
                break
        return self.wlan.isconnected()
    
    def disconnect(self):
        self.wlan.disconnect()

    def connectedInfo(self):
        apInfo = self.wlan.joined_ap_info()
        return {
            'bssid':   apInfo.bssid,
            'ssid':    apInfo.ssid,
            'channel': apInfo.primary_chn,
            'rssi':    apInfo.rssi
        }
    
    def connectedRssi(self):
        return self.wlan.joined_ap_info().rssi
