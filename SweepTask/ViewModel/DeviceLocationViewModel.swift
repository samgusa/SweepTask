//
//  DeviceLocationViewModel.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

class DeviceLocationViewModel: ObservableObject {

    @ObservedObject var bluetoothManager: BluetoothManager
    let device: ScannedDevice

    init(bluetoothManager: BluetoothManager, device: ScannedDevice) {
        self.bluetoothManager = bluetoothManager
        self.device = device
    }

    func getProximityRange(for distance: Double) -> ProximityRange {
        switch distance {
        case 0..<0.5:
            return .nextTo
        case 0.5..<1:
            return .nextToVeryClose
        case 1..<2:
            return .veryClose
        case 2..<3:
            return .closer
        case 3..<4:
            return .close
        case 4..<5:
            return .mediumClose
        case 5..<6:
            return .medium
        case 6..<7:
            return .mediumFar
        case 7..<8:
            return .far
        case 8..<9:
            return .veryFar
        default:
            return .outOfRange
        }
    }
}
