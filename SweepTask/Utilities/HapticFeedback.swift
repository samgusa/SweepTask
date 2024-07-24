//
//  HapticFeedback.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import Foundation
import CoreHaptics

class HapticFeedback {
    private var engine: CHHapticEngine?

    init() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }

    func provideFeedback(intensity: Float) {
        guard let engine = engine else { return }

        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: intensity)
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)

        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensityParameter], relativeTime: 0)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to provide haptic feedback: \(error)")
        }
    }
}

