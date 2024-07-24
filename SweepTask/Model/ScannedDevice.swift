//
//  ScannedDevice.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import Foundation
import CoreBluetooth

struct ScannedDevice: Identifiable, Equatable {
    let id = UUID()
    var peripheral: CBPeripheral
    var rssi: Int

    static func == (lhs: ScannedDevice, rhs: ScannedDevice) -> Bool {
        return lhs.peripheral.identifier == rhs.peripheral.identifier
    }
}
