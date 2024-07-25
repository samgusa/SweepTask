//
//  ProximityRange.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import Foundation
import SwiftUI

enum ProximityRange {
    case nextTo
    case nextToVeryClose
    case veryClose
    case closer
    case close
    case mediumClose
    case medium
    case mediumFar
    case far
    case veryFar
    case outOfRange

    var color: Color {
        switch self {
        case .nextTo, .nextToVeryClose, .veryClose, .closer, .close:
            return .green
        case .mediumClose, .medium, .mediumFar, .far, .veryFar, .outOfRange:
            return .red
        }
    }

    var circleSize: CGFloat {
        switch self {
        case .nextTo:
            return 15
        case .nextToVeryClose:
            return 20
        case .veryClose:
            return 25
        case .closer:
            return 30
        case .close:
            return 50
        case .mediumClose:
            return 60
        case .medium:
            return 80
        case .mediumFar:
            return 100
        case .far:
            return 110
        case .veryFar:
            return 130
        case .outOfRange:
            return 150
        }
    }

    var hapticIntensity: CGFloat {
        switch self {
        case .nextTo, .nextToVeryClose:
            return 1.0
        case .veryClose, .closer:
            return 0.8
        case .close, .mediumClose:
            return 0.6
        case .medium, .mediumFar:
            return 0.4
        case .far, .veryFar:
            return 0.2
        case .outOfRange:
            return 0.0
        }
    }
}
