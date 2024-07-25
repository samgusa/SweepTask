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
    @Published var backgroundColor: Color = .red
    @Published var circleSize: CGFloat = 150
    @Published var hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    @Published var isLoading: Bool = true

    init(bluetoothManager: BluetoothManager, device: ScannedDevice) {
        self.bluetoothManager = bluetoothManager
        self.device = device
    }

    func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                self.isLoading = false
            }
        }
    }

    func calculateDistance(rssi: Int) -> Double {
        let txPower = -59
        let ratio = Double(rssi) / Double(txPower)
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return (0.89976 * pow(ratio, 7.7095)) + 0.111
        }
    }

    func updateProximity(rssi: Int) {
        let distance = calculateDistance(rssi: rssi)

        let proximityRange = getProximityRange(for: distance)
        circleSize = proximityRange.circleSize
        backgroundColor = proximityRange.color

        let intensity = proximityRange.hapticIntensity
        if intensity > 0 {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        }
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
