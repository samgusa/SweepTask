//
//  PulseEffectHelper.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import SwiftUI

struct PulseEffect<S: Shape>: ViewModifier {
    var shape: S
    @State var isOn: Bool = false
    var animation: Animation {
        Animation
            .easeIn(duration: 1)
            .repeatForever(autoreverses: false)
    }

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    shape
                        .stroke(Color.white, lineWidth: 1)
                        .scaleEffect(self.isOn ? 20 : 1)
                        .opacity(self.isOn ? 0 : 1)
                    shape
                        .stroke(Color.white)
            })
            .onAppear {
                withAnimation(self.animation) {
                    self.isOn = true
                }
        }
    }
}

public extension View {
    func pulse<S: Shape>(_ shape: S) -> some View  {
        self.modifier(PulseEffect(shape: shape))
    }
}
