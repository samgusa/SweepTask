import SwiftUI
import CoreBluetooth

struct DeviceLocationView: View {
    @ObservedObject var viewModel: BluetoothViewModel
    let device: ScannedDevice
    @State private var backgroundColor: Color = .red
    @State private var circleSize: CGFloat = 150
    @State private var hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    @State private var isLoading: Bool = true

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
                            .frame(width: circleSize, height: circleSize)
                            .foregroundStyle(.white)
                            .animation(.easeInOut, value: circleSize)

                        Text(String(format: "%.2f meters", calculateDistance(rssi: device.rssi)))
                            .font(.title2)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.startUpdatingRSSI(for: device)
            startLoading()
        }
        .onDisappear {
            viewModel.stopUpdatingRSSI()
        }
        .onChange(of: device.rssi) { oldValue, newValue in
            updateProximity(rssi: newValue)
        }
        .navigationTitle(device.name)
    }

    private func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                isLoading = false
            }
        }
    }

    private func calculateDistance(rssi: Int) -> Double {
        let txPower = -59
        let ratio = Double(rssi) / Double(txPower)
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return (0.89976 * pow(ratio, 7.7095)) + 0.111
        }
    }

    private func updateProximity(rssi: Int) {
        let distance = calculateDistance(rssi: rssi)

        let proximityRange = getProximityRange(for: distance)
        circleSize = proximityRange.circleSize
        backgroundColor = proximityRange.color

        let intensity = proximityRange.hapticIntensity
        if intensity > 0 {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        }
    }


    private func getProximityRange(for distance: Double) -> ProximityRange {
        switch distance {
        case 0..<0.5:
            return .nextTo
        case 0.5..<1:
            return .nextToVeryClose
        case 1..<2:
            return .veryClose
        case 2..<3:
            return .closer
        case 3..<4:
            return .close
        case 4..<5:
            return .mediumClose
        case 5..<6:
            return .medium
        case 6..<7:
            return .mediumFar
        case 7..<8:
            return .far
        case 8..<9:
            return .veryFar
        default:
            return .outOfRange
        }
    }


}

#Preview {
    DeviceLocationView(viewModel: BluetoothViewModel(), device: ScannedDevice(id: UUID(), name: "Test Device", rssi: -10))
}



