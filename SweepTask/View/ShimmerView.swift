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

            VStack(alignment: .center, spacing: 20) {
                Circle()
                    .frame(width: 150, height: 150)

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 150, height: 30)

            }
            .foregroundStyle(.white)
            .shimmer(.init(tint: .white, highlight: .black.opacity(0.5)), animation: $startAnimation)
        }
    }
}


#Preview {
    ShimmerView(startAnimation: .constant(true))
}


