from src import ble_scanning

if __name__ == '__main__':
    connected_history = {}
    edge_service = ble_scanning.Service(30)
    edge_service.start()
