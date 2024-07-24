//
//  SignalStrengthView.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import SwiftUI

struct SignalStrengthView: View {
    var signalModel: SignalStrengthModel

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                let color: Color = index < signalModel.signalBars ? signalModel.barColor : Color.gray
                Rectangle()
                    .fill(color)
                    .frame(width: 3, height: CGFloat(3 * (index + 1)))
            }
        }
    }
}

#Preview {
    SignalStrengthView(signalModel: SignalStrengthModel(rssi: -10))
}
