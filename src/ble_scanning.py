import time
import os
import requests
from colorama import Fore, Back, init
from beacontools import BeaconScanner, IBeaconAdvertisement


class Service:
    def __init__(self, threshold):
        self.connected_history = {}
        self.threshold = threshold
        self._scanner = BeaconScanner(callback=self.callback, packet_filter=IBeaconAdvertisement)
        init(autoreset=True)
        self._scanner.start()

    def callback(self, bt_addr, rssi, packet, additional_info):
        current_time = time.perf_counter()
        self.connected_history.setdefault(bt_addr, current_time)

    def start(self):
        is_scanned = False
        while True:
            for history in self.connected_history.items():
                if time.perf_counter() - history[1] > self.threshold:
                    print(Fore.LIGHTWHITE_EX + Back.LIGHTGREEN_EX + " OUT {0} {1}"
                          .format(Back.RESET, history[0]))
                    submit(history[0])
                    is_scanned = True
                else:
                    diff = time.perf_counter() - history[1]
                    print(Fore.LIGHTWHITE_EX + Back.LIGHTBLUE_EX + " LISTING {0} {1} {2}"
                          .format(Back.RESET, history, diff))

            time.sleep(10)

            if is_scanned:
                self.connected_history.clear()
                is_scanned = False


def submit(bt_addr):
    param = {'uuid': bt_addr}
    response = requests.post(os.getenv("API_HOST"), data=param)
    if response.status_code == 200:
        print(Fore.LIGHTWHITE_EX + Back.LIGHTGREEN_EX + " OK {0} {1}".format(Back.RESET, response.text))
