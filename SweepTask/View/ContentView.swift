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
                    NavigationLink(destination: DeviceLocationView()) {
                        HStack {
                            Text(device.peripheral.name ?? "Unknown")
                            Spacer()
                            Text("\(device.rssi) dBm")
                        }
                    }
                }
                .navigationTitle("Bluetooth Devices")
//                .toolbar(content: {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Image(systemName: "ellipsis")
//                    }
//                })
            }
        }
}

#Preview {
    ContentView()
}
