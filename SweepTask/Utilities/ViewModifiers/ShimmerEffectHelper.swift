//
//  ShimmerEffectHelper.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import SwiftUI

struct ShimmerEffectHelper: ViewModifier {
    var config: ShimmerConfig
    @State private var moveTo: CGFloat = -0.7
    @Binding var startAnimation: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .hidden()

            Rectangle()
                .fill(config.tint)
                .mask(content)
                .overlay(
                    GeometryReader { geometry in
                        let size = geometry.size
                        let extraOffset = size.height / Constants.xtraOffset

                        Rectangle()
                            .fill(config.highlight)
                            .mask(
                                Rectangle()
                                    .fill(
                                        .linearGradient(
                                            colors: [.white.opacity(0), config.highlight.opacity(config.highlightOpacity), .white.opacity(0)],
                                            startPoint: .leading,
                                            endPoint: .trailing // Horizontal gradient for sides blur
                                        )
                                    )
                                    .blur(radius: config.blur)
                                    .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                    .offset(x: size.width * moveTo)
                            )
                            .frame(width: size.width, height: size.height)
                    }
                )
                .mask(content)
                .onAppear {
                    DispatchQueue.main.async {
                        moveTo = Constants.moveToValue
                    }
                }
                .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
        }
    }

    private enum Constants {
        static let moveToValue: CGFloat = 0.7
        static let xtraOffset: CGFloat = 2.5
    }
}

#Preview {
    ShimmerView(startAnimation: .constant(true))
}
