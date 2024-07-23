//
//  DeviceLocationView.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import SwiftUI
import CoreBluetooth

struct DeviceLocationView: View {
    var device: ScannedDevice
    @State private var distance: CGFloat = 0
    @State private var backgroundColor: Color = .red
    @State private var circleSize: CGFloat = 100
//
    var hapticFeedback = HapticFeedback()

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

