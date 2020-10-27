import time
from beacontools import BeaconScanner, IBeaconAdvertisement


def callback(bt_addr, rssi, packet, additional_info):
    print("<%s, %d> %s %s" % (bt_addr, rssi, packet, additional_info))


# scan for all iBeacon advertisements regardless from which beacon
scanner = BeaconScanner(callback, packet_filter=IBeaconAdvertisement)
scanner.start()
time.sleep(5)
scanner.stop()
