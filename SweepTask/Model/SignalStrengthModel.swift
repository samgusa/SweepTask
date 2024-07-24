//
//  SignalStrengthModel.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import SwiftUI

struct SignalStrengthModel {
    var rssi: Int

    var signalBars: Int {
            switch rssi {
            case ..<(-80):
                return 1
            case -80..<(-70):
                return 2
            case -70..<(-60):
                return 3
            case -60..<(-50):
                return 4
            case -50...Int.max:
                return 5
            default:
                return 0
            }
        }

    var barColor: Color {
            switch signalBars {
            case 1...2:
                return .red
            case 3:
                return .orange
            case 4...5:
                return .green
            default:
                return .gray
            }
        }
}
