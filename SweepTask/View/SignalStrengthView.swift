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
                let color: Color = index < signalModel.signalBars ? signalModel.barColor : Constants.grayColor
                Rectangle()
                    .fill(color)
                    .frame(
                        width: Constants.rectangleFrameCG,
                        height: CGFloat(Constants.rectangleFrameInt * (index + Constants.rectangleIndexAdd)))
            }
        }
    }

    private enum Constants {
        static let grayColor: Color = .gray
        static let rectangleFrameCG: CGFloat = 3
        static let rectangleFrameInt: Int = 3
        static let rectangleIndexAdd: Int = 1
    }
}

#Preview {
    SignalStrengthView(signalModel: SignalStrengthModel(rssi: -10))
}
