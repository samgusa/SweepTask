//
//  ScannedDevice.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import Foundation
import CoreBluetooth
import SwiftUI

struct ScannedDevice: Identifiable, Equatable {
    let id: UUID
    var name: String
    var rssi: Int

    var backgroundColor: Color {
            switch rssi {
            case ..<(-80):
                return .red
            case -80..<(-40):
                return .red
            case -40..<(-10):
                return .green
            case -10...Int.max:
                return .green
            default:
                return .red
            }
        }
}
