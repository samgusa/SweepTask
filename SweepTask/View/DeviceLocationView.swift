import SwiftUI
import CoreBluetooth

struct DeviceLocationView: View {
    @ObservedObject var viewModel: DeviceLocationViewModel
    @State var backgroundColor: Color = .red
    @State var circleSize: CGFloat = 150
    @State var hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    @State var isLoading: Bool = true
    @State var isPulsing: Bool = false
    @State var showNotification: Bool = false
    
    
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
                        if isPulsing {
                            // True
                            Circle()
                                .frame(
                                    width: circleSize,
                                    height: circleSize)
                                .foregroundStyle(.white)
                                .animation(.easeInOut,
                                           value: circleSize)
                                .pulse(Circle())
                        } else {
                            // False
                            Circle()
                                .frame(
                                    width: circleSize,
                                    height: circleSize)
                                .foregroundStyle(.white)
                                .animation(.easeInOut,
                                           value: circleSize)
                        }
                        Text(String(format: "%.2f meters",
                                    calculateDistance(rssi: viewModel.device.rssi)))
                        .font(Constants.textFont)
                        .padding(.top)
                    }
                    
                    
                    CustomNotifs(systemIcon: "star.fill", iconColor: .green,
                                 notifText: "You are near your device")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .opacity(showNotification ? 1 : 0)
                    .offset(y: showNotification ? 0 : -200)
                    .padding()
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
        static let VStackSpacing: CGFloat = 20
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
        
        if proximityRange == .nextTo {
            isPulsing = true
            withAnimation {
                self.showNotification = true
            }
        } else {
            isPulsing = false
            withAnimation {
                self.showNotification = false
            }
        }
        
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



