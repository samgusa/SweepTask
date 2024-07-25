# Sweep360 Task
by Sam Greenhill 

## Features
* Bluetooth enabled iOS app in SwiftUI.
* Custom Animations, including pulsing and custom loader
* Bluetooth enabled device location detection.
* Custom Customizable Notifications


## Video:

https://github.com/user-attachments/assets/70b4f6bb-6d64-44ab-a8f6-4c2501d97e36

## Favorite Code Snippets: 

```swift

struct ShimmerEffectHelper: ViewModifier {
    var config: ShimmerConfig
    @State private var moveTo: CGFloat = -0.7
    @Binding var startAnimation: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .hidden()

            Rectangle()
                .fill(config.tint)
                .mask(content)
                .overlay(
                    GeometryReader { geometry in
                        let size = geometry.size
                        let extraOffset = size.height / Constants.xtraOffset

                        Rectangle()
                            .fill(config.highlight)
                            .mask(
                                Rectangle()
                                    .fill(
                                        .linearGradient(
                                            colors: [.white.opacity(0), config.highlight.opacity(config.highlightOpacity), .white.opacity(0)],
                                            startPoint: .leading,
                                            endPoint: .trailing // Horizontal gradient for sides blur
                                        )
                                    )
                                    .blur(radius: config.blur)
                                    .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                    .offset(x: size.width * moveTo)
                            )
                            .frame(width: size.width, height: size.height)
                    }
                )
                .mask(content)
                .onAppear {
                    DispatchQueue.main.async {
                        moveTo = Constants.moveToValue
                    }
                }
                .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
        }
    }

    private enum Constants {
        static let moveToValue: CGFloat = 0.7
        static let xtraOffset: CGFloat = 2.5
    }
}
```


```swift
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
```
