//
//  SignalStrengthView.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import SwiftUI

struct SignalStrengthView: View {
    var rssi: Int

    private var signalBars: Int {
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

    private var barColor: Color {
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

    var body: some View {
        HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Rectangle()
                            .fill(index < signalBars ? barColor : Color.gray)
                            .frame(width: 3, height: CGFloat(3 * (index + 1)))
                    }
                }
    }
}

#Preview {
    SignalStrengthView(rssi: -10)
}
