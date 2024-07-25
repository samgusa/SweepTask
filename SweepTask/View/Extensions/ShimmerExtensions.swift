//
//  ShimmerExtensions.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig, animation: Binding<Bool>) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config, startAnimation: animation))
    }
}
