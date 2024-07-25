//
//  ContentView.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var bluetoothManager = BluetoothManager()

    var body: some View {
            NavigationView {
                List(bluetoothManager.devices) { device in
                    NavigationLink(
                        destination: DeviceLocationView(
                            viewModel: DeviceLocationViewModel(
                                bluetoothManager: bluetoothManager, device: device))) {
                        HStack {
                            Text(device.name)
                            Spacer()
                            SignalStrengthView(
                                signalModel: SignalStrengthModel(
                                    rssi: device.rssi))
                        }
                    }
                }
                .navigationTitle("Bluetooth Devices")
            }
        }
}

#Preview {
    ContentView()
}
