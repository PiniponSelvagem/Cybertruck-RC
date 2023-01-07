"""
BLE simplified driver wrapper.
"""

from network import Bluetooth
import binascii

class BLE():
    TG_CLIENT_CONNECTED     = Bluetooth.CLIENT_CONNECTED
    TG_CLIENT_DISCONNECTED  = Bluetooth.CLIENT_DISCONNECTED
    TG_NEW_ADV_EVENT        = Bluetooth.NEW_ADV_EVENT
    TG_CHAR_READ_EVENT      = Bluetooth.CHAR_READ_EVENT
    TG_CHAR_WRITE_EVENT     = Bluetooth.CHAR_WRITE_EVENT
    TG_CHAR_NOTIFY_EVENT    = Bluetooth.CHAR_NOTIFY_EVENT
    TG_CHAR_SUBSCRIBE_EVENT = Bluetooth.CHAR_SUBSCRIBE_EVENT

    def __init__(self, deviceName):
        self.devicename = deviceName
        self.ble = Bluetooth()
        self.ble.tx_power(Bluetooth.TX_PWR_ADV, Bluetooth.TX_PWR_P9)
        self.advertiserCreated = False

    def createAdvertiser(self, serviceUUID, cb, cbTrigger):
        if (self.advertiserCreated == False):
            self.ble.set_advertisement(name=self.devicename, service_uuid=self.uuid2bytes(serviceUUID))
            #self.ble.callback(trigger=Bluetooth.CLIENT_CONNECTED | Bluetooth.CLIENT_DISCONNECTED, handler=self.basic_connectionCallback)
            self.ble.callback(trigger=cbTrigger, handler=cb)
            self.ble.advertise(True)
            self.advertiserCreated = True
            return True
        return False

    def createService(self, uuidService, uuidCharacteristic, cb, cbTrigger):
        #### CURRENTLY ONLY SUPPORTING 1 CHARC PER SERVICE ####
        srv = self.ble.service(uuid=self.uuid2bytes(uuidService), isprimary=True)
        chr = srv.characteristic(uuid=self.uuid2bytes(uuidCharacteristic), value=1)
        chr_cb = chr.callback(trigger=cbTrigger, handler=cb)
        return chr
        """
        srv1 = self.ble.service(uuid=b'1234567890123456', isprimary=True)
        chr1 = srv1.characteristic(uuid=b'ab34567890123456', value=1)
        char1_cb = chr1.callback(trigger=Bluetooth.CHAR_WRITE_EVENT | Bluetooth.CHAR_READ_EVENT, handler=self.char1_cb_handler)
        """

    def uuid2bytes(self, uuid):
        # taken from: https://forum.pycom.io/topic/530/working-with-uuid/6#
        uuid = uuid.encode().replace(b'-',b'')
        tmp = binascii.unhexlify(uuid)
        return bytes(reversed(tmp))




    def example_cb_handler(self, chr, data):
        events, value = data
        print(events)
        if events & Bluetooth.CHAR_WRITE_EVENT:
            print("Write request with value = {}".format(value))
        else:
            print('Read request on char 1')

    def example_connectionCallback(bt_o):
        events = bt_o.events()
        if events & Bluetooth.CLIENT_CONNECTED:
            print("Client connected")
        elif events & Bluetooth.CLIENT_DISCONNECTED:
            print("Client disconnected")


"""
def scan(self):
    from ubinascii import hexlify
    self.ble.start_scan(-1)
    adv = None
    name = ""
    manufacturer = ""
    while True:
        adv = self.ble.get_adv()
        if adv:
            #try:
                print("\t\tMac address : " + str(hexlify(adv.mac)))
                print("\t\tData : " + str(hexlify(adv.data)))
                name = self.ble.resolve_adv_data(adv.data, Bluetooth.ADV_NAME_CMPL)
                manufacturer = self.ble.resolve_adv_data(adv.data, Bluetooth.ADV_MANUFACTURER_DATA)
                print("\t\tName : " + str(name))
                print("\t\tManufacturer : " + str(manufacturer))
                if name=="BLE WBM":
                    self.ble.connect(adv.mac)
                    self.ble.stop_scan()
                    break
            #except:
                # start scanning again
                ##self.ble.start_scan(-1)
            #    continue
            #break
    print("Connected to device with addr = {}".format(hexlify(adv.mac)))
"""

"""
def UUIDbytes2UUIDstring(uuid):
    from ubinascii import hexlify
    tmp = str(hexlify(bytes(reversed(uuid))))[2:34]
    return tmp[0:8]+'-'+tmp[8:12]+'-'+tmp[12:16]+'-'+tmp[16:20]+'-'+tmp[20:32]

import binascii
from network import Bluetooth

def bleScannerTask():
    bt = Bluetooth()
    bt.start_scan(-1)

    while True:
        adv = bt.get_adv()
        if adv and bt.resolve_adv_data(adv.data, Bluetooth.ADV_NAME_CMPL) == 'Sensor':
            try:
                print("connecting to "+UUIDbytes2UUIDstring(adv.mac))
                conn = bt.connect(adv.mac)
                print("connected")
                while True:
                    services = conn.services()
                    global s
                    s = services
                    for service in services:
                        sleep_ms(50)
                        if type(service.uuid()) == bytes:
                            print('Reading chars from service = {}'.format(service.uuid()))
                        else:
                            print('Reading chars from service = %x' % service.uuid())
                        chars = service.characteristics()
                        for char in chars:
                            if (char.properties() & Bluetooth.PROP_READ):
                                print('char {} value = {}'.format(char.uuid(), char.read()))
                            else:
                                print('char {} value = {}'.format(char.uuid(), char.value()))
                conn.disconnect()
            except:
                pass
        else:
            sleep_ms(100)


Thread.start_new_thread(bleScannerTask, ())
""


""
from network import Bluetooth
def bleAdvertiserTask():
    bluetooth = Bluetooth()
    bluetooth.init()
    bluetooth.set_advertisement(name='OpenPark', manufacturer_data = 'ESP32',  service_data = b'19950922' ,service_uuid=b'1000000010000000')
    def conn_cb (bt_o):
        events = bt_o.events() # this method returns the flags and clears the internal registry
        if  events & Bluetooth.CLIENT_CONNECTED:
            print("Client connected")
            bt_o.advertise(False)
        elif events & Bluetooth.CLIENT_DISCONNECTED:
            print("Client disconnected")
            bt_o.advertise(True)
    bluetooth.callback(trigger=Bluetooth.CLIENT_CONNECTED | Bluetooth.CLIENT_DISCONNECTED, handler=conn_cb)
    #start advertise
    bluetooth.advertise(True)
    #Create a new service on the internal GATT server. Returns a object of type BluetoothServerService.
    #bluetooth.service(uuid, *, isprimary=True, nbr_chars=1, start=True)
    srv1 = bluetooth.service(uuid=b'1000000010000000', isprimary=True, nbr_chars=1, start = True)
    chr1 = srv1.characteristic(uuid = b'ab34567890123456', properties = (Bluetooth.PROP_READ | Bluetooth.PROP_WRITE), value=99999)#,  permissions = (1 << 0) | (1 << 4))
    def char1_cb_handler(chr, test):
        global tx_str
        events = chr.events()
        if  events & Bluetooth.CHAR_WRITE_EVENT:
            print("Write request with value = {}".format(chr.value()))
            print(str(test))
            global available
            available = test
        else:
            print('Read request on char 1')
            ##########################################################
            # Not sure if I call something here or set it separately #
            ##########################################################
    char1_cb = chr1.callback(trigger=Bluetooth.CHAR_WRITE_EVENT | Bluetooth.CHAR_READ_EVENT, handler=char1_cb_handler)

    while True:
        pass

Thread.start_new_thread(bleAdvertiserTask, ())
"""