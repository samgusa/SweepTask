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

            Circle()
                .frame(
                    width: Constants.circleFrame,
                    height: Constants.circleFrame)
                .foregroundStyle(.white)
                .shimmer(
                    .init(
                        tint: .white,
                        highlight: .black.opacity(Constants.blackOpacity)),
                    animation: $startAnimation)
                .padding(.bottom, 15)
        }
    }

    private enum Constants {
        static let blackOpacity: CGFloat = 0.5
        static let circleFrame: CGFloat = 150
        static let VStackSpacing: CGFloat = 20
    }
}


#Preview {
    ShimmerView(startAnimation: .constant(true))
}


