import SwiftUI
import CoreBluetooth

struct DeviceLocationView: View {
    @ObservedObject var viewModel: DeviceLocationViewModel
    @State var backgroundColor: Color = .red
    @State var circleSize: CGFloat = 150
    @State var hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    @State var isLoading: Bool = true


    var body: some View {
        ZStack {
            if isLoading {
                ShimmerView(startAnimation: $isLoading)
            } else {
                ZStack {
                    backgroundColor
                        .ignoresSafeArea(.all)
                        .animation(.easeInOut, value: backgroundColor)
                    VStack {

                        Circle()
                            .frame(
                                width: circleSize,
                                height: circleSize)
                            .foregroundStyle(.white)
                            .animation(.easeInOut,
                                       value: circleSize)

                        Text(String(format: "%.2f meters", 
                                    calculateDistance(rssi: viewModel.device.rssi)))
                            .font(Constants.textFont)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.bluetoothManager
                .startUpdatingRSSI(for: viewModel.device)
            startLoading()
        }
        .onDisappear {
            viewModel.bluetoothManager
                .stopUpdatingRSSI()
        }
        .onChange(of: viewModel.device.rssi) { oldValue, newValue in
            updateProximity(rssi: newValue)
        }
        .navigationTitle(viewModel.device.name)
    }

    private enum Constants {
        static let textFont: Font = .title2
    }

    func calculateDistance(rssi: Int) -> Double {
        let txPower = -59
        let ratio = Double(rssi) / Double(txPower)
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return (0.89976 * pow(ratio, 7.7095)) + 0.111
        }
    }

    func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                isLoading = false
            }
        }
    }

    func updateProximity(rssi: Int) {
        let distance = calculateDistance(rssi: rssi)

        let proximityRange = viewModel.getProximityRange(for: distance)
        circleSize = proximityRange.circleSize
        backgroundColor = proximityRange.color

        let intensity = proximityRange.hapticIntensity
        if intensity > 0 {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        }
    }
}

#Preview {
    DeviceLocationView(
        viewModel: DeviceLocationViewModel(
            bluetoothManager: BluetoothManager(),
            device: ScannedDevice(
                id: UUID(),
                name: "Test Device",
                rssi: -10)))
}



