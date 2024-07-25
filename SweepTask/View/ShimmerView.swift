//
//  ShimmerView.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import SwiftUI

struct ShimmerView: View {

    @Binding var startAnimation: Bool
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea(.all)

            VStack(alignment: .center, spacing: Constants.VStackSpacing) {
                Circle()
                    .frame(
                        width: Constants.circleFrame,
                        height: Constants.circleFrame)

                RoundedRectangle(
                    cornerRadius: Constants.rectangleCornerRadius)
                    .frame(
                        width: Constants.rectangleWidth,
                        height: Constants.rectangleHeight)

            }
            .foregroundStyle(.white)
            .shimmer(
                .init(
                    tint: .white,
                    highlight: .black.opacity(Constants.blackOpacity)),
                animation: $startAnimation)
        }
    }

    private enum Constants {
        static let VStackSpacing: CGFloat = 20
        static let circleFrame: CGFloat = 150
        static let rectangleCornerRadius: CGFloat = 4
        static let rectangleWidth: CGFloat = 150
        static let rectangleHeight: CGFloat = 30
        static let blackOpacity: CGFloat = 0.5
    }
}


#Preview {
    ShimmerView(startAnimation: .constant(true))
}


