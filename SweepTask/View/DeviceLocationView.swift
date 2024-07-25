import SwiftUI
import CoreBluetooth

struct DeviceLocationView: View {
    @ObservedObject var viewModel: DeviceLocationViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ShimmerView(startAnimation: $viewModel.isLoading)
            } else {
                ZStack {
                    viewModel.backgroundColor
                        .ignoresSafeArea(.all)
                        .animation(.easeInOut, value: viewModel.backgroundColor)
                    VStack {

                        Circle()
                            .frame(width: viewModel.circleSize, height: viewModel.circleSize)
                            .foregroundStyle(.white)
                            .animation(.easeInOut, value: viewModel.circleSize)

                        Text(String(format: "%.2f meters", viewModel.calculateDistance(rssi: viewModel.device.rssi)))
                            .font(.title2)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.bluetoothManager.startUpdatingRSSI(for: viewModel.device)
            viewModel.startLoading()
        }
        .onDisappear {
            viewModel.bluetoothManager.stopUpdatingRSSI()
        }
        .onChange(of: viewModel.device.rssi) { oldValue, newValue in
            viewModel.updateProximity(rssi: newValue)
        }
        .navigationTitle(viewModel.device.name)
    }

}

#Preview {
    DeviceLocationView(viewModel: DeviceLocationViewModel(viewModel: BluetoothManager(), device: ScannedDevice(id: UUID(), name: "Test Device", rssi: -10)))
}



