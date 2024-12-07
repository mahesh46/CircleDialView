//
//  ContentView.swift
//  CircleDail_SwiftUI
//
//  Created by mahesh lad on 07/12/2024.
//

import SwiftUI

struct CircularDialView: View {
    @State private var value: Double = 0.0 // Current slider value

    var body: some View {
        VStack {
            ZStack {
                // Circular gradient background
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]),
                            center: .center
                        ),
                        lineWidth: 20
                    )
                    .opacity(0.3)

                // Progress arc
                Circle()
                    .trim(from: 0.0, to: CGFloat(value / 100))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90)) // Start arc from top
                    .animation(.easeInOut, value: value)

                // Knob positioned on the curve
                KnobOnCurveView(value: $value)
                    .frame(width: 300, height: 300)
            }
            .frame(width: 300, height: 300)

            // Display value
            Text("Value: \(Int(value))")
                .font(.title)
                .padding()
        }
    }
}

struct KnobOnCurveView: View {
    @Binding var value: Double

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let radius = min(size.width, size.height) / 2 - 20 // Adjust for line width
            let angle = Angle(degrees: value / 100 * 360) - .degrees(90) // Adjust to start from top

            // Calculate knob position on the curve
            let knobX = radius * cos(angle.radians) + size.width / 2
            let knobY = radius * sin(angle.radians) + size.height / 2

            ZStack {
                // Draggable knob
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 4)
                    .frame(width: 30, height: 30)
                    .position(x: knobX, y: knobY)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                updateValue(with: gesture, in: size)
                            }
                    )
            }
        }
    }

    private func updateValue(with gesture: DragGesture.Value, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let touchPoint = gesture.location

        // Calculate the angle of the touch point
        let angle = atan2(touchPoint.y - center.y, touchPoint.x - center.x) + .pi / 2
        var normalizedAngle = angle < 0 ? angle + 2 * .pi : angle

        let progress = normalizedAngle / (2 * .pi)
        let newValue = progress * 100

        value = max(0, min(100, newValue)) // Clamp the value between 0 and 100
    }
}


#Preview {
    CircularDialView()
}
