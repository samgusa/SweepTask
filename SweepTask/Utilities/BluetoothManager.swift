//
//  BluetoothManager.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

//
//  BluetoothViewModel.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var devices: [ScannedDevice] = []
    @Published var selectedDevice: ScannedDevice?
    private var centralManager: CBCentralManager!
    private var timer: Timer?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = ScannedDevice(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue)
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].rssi = RSSI.intValue
        } else {
            devices.append(device)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            // Handle other states
        }
    }

    func startUpdatingRSSI(for device: ScannedDevice) {
        selectedDevice = device
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func stopUpdatingRSSI() {
        timer?.invalidate()
        timer = nil
    }
}
