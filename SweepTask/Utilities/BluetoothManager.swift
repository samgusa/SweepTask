//
//  BluetoothManager.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var devices: [ScannedDevice] = []
    var centralManager: CBCentralManager!
    var calculatedDistance: Double!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        } else {
            print("Bluetooth is not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Update or add the device to the scannedDevices array
        let scannedDevice = ScannedDevice(peripheral: peripheral, rssi: RSSI.intValue)
        // Update your list of devices or notify the UI
        devices.append(scannedDevice)
        // Notify the UI or handle it as needed
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        guard error == nil else {
            print("Error updating RSSI: \(error!.localizedDescription)")
            return
        }
        // Update the device's RSSI in the scannedDevices array
        if let index = devices.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
            devices[index].rssi = RSSI.intValue
        }
    }
    
}
