import SwiftUI

struct DeviceLocationView: View {
    @State var device: ScannedDevice // Use @State for mutable properties
    @State private var distance: CGFloat = 0
    @State private var backgroundColor: Color = .red
    @State private var circleSize: CGFloat = 100

    var hapticFeedback = HapticFeedback()
    @State private var timer: Timer? // Store the timer instance

    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: backgroundColor)

            VStack {
                Text("Proximity to Device")
                    .font(.title)
                    .padding()

                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .foregroundColor(.white)
                    .animation(.easeInOut, value: circleSize)

                Text(String(format: "%.2f meters", distance))
                    .font(.title2)
                    .padding()
            }
        }
        .onAppear {
            startUpdatingProximity() // Replace with simulateRSSIChange() for testing
        }
        .onDisappear {
            stopUpdatingProximity()
        }
    }

    private func startUpdatingProximity() {
           // Simulate proximity changes for demonstration purposes.
           // Replace this with real RSSI-based distance calculations.
           Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
               let rssi = device.rssi
               let proximity = calculateProximity(rssi: rssi)

               distance = proximity
               updateUI(proximity: proximity)
               hapticFeedback.provideFeedback(intensity: Float(1.0 / proximity))
           }
       }

    private func stopUpdatingProximity() {
        timer?.invalidate()
        timer = nil
    }

    private func calculateProximity(rssi: Int) -> Double {
        let txPower = -59
        let ratio = Double(rssi) / Double(txPower)
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return (0.89976 * pow(ratio, 7.7095)) + 0.111
        }
    }

    private func updateUI(proximity: CGFloat) {
        if proximity < 1.0 {
            backgroundColor = .green
            circleSize = 100
        } else {
            backgroundColor = .red
            circleSize = min(300, 100 + (proximity - 1) * 100)
        }
    }
}

/*
 private func startUpdatingProximity() {
        // Simulate proximity changes for demonstration purposes.
        // Replace this with real RSSI-based distance calculations.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let rssi = device.rssi
            let proximity = calculateProximity(rssi: rssi)

            distance = proximity
            updateUI(proximity: proximity)
            hapticFeedback.provideFeedback(intensity: Float(1.0 / proximity))
        }
    }

 private func stopUpdatingProximity() {
     timer?.invalidate()
     timer = nil
 }

    private func calculateProximity(rssi: Int) -> CGFloat {
        let txPower: CGFloat = -59 // Example TX power value
        let ratio = CGFloat(rssi) / txPower
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return 0.89976 * pow(ratio, 7.7095) + 0.111
        }
    }

    private func updateUI(proximity: CGFloat) {
        if proximity < 1.0 {
            backgroundColor = .green
            circleSize = 100
        } else {
            backgroundColor = .red
            circleSize = 300
        }
    }


 */
