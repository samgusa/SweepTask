import SwiftUI
import CoreBluetooth

struct DeviceLocationView: View {
    @ObservedObject var viewModel: BluetoothViewModel
    let device: ScannedDevice
    @State private var backgroundColor: Color = .red
    @State private var circleSize: CGFloat = 150
    @State private var hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
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
        .onAppear {
            viewModel.startUpdatingRSSI(for: device)
        }
        .onDisappear {
            viewModel.stopUpdatingRSSI()
        }
        .onChange(of: device.rssi) { oldValue, newValue in
            updateProximity(rssi: newValue)
        }
        .navigationTitle(device.name)
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
