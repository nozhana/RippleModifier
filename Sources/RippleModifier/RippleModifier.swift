//
//  RippleModifier.swift
//  RippleModifier
//
//  Created by Nozhan A. on 9/28/25.
//

import SwiftUI

struct RippleModifier: ViewModifier {
    var speed: Float = 1.0
    var aberration: Float = 0.2
    var ringThickness: Float = 0.45
    var intensity: Float = 0.15
    
    @State private var tapLocation = CGPoint.zero
    @State private var isRippling = false
    @State private var resetTask: Task<Void, Error>?
    
    func body(content: Content) -> some View {
        Group {
            if isRippling {
                let startDate = Date.now
                let tap = tapLocation
                TimelineView(.animation) { timeline in
                    let timeOffset = timeline.date.timeIntervalSince(startDate)
                    content
                        .drawingGroup()
                        .visualEffect { c, proxy in
                            let center = CGVector(
                                dx: tap.x / proxy.size.width,
                                dy: tap.y / proxy.size.height
                            )
                            return c.layerEffect(
                                ShaderLibrary.bundle(.module).ripple(
                                    .float2(center),
                                    .float2(proxy.size),
                                    .float(timeOffset),
                                    .float(speed * 1.35),
                                    .float(aberration),
                                    .float(ringThickness),
                                    .float(intensity)
                                ),
                                maxSampleOffset: .zero
                            )
                        }
                }
            } else {
                content
            }
        }
        .onTapGesture { point in
            tapLocation = point
            isRippling = true
            resetTask?.cancel()
            resetTask = Task {
                try await Task.sleep(for: .seconds(1))
                try Task.checkCancellation()
                isRippling = false
            }
        }
    }
}

extension View {
    public func rippling(speed: Float = 1.0,
                         aberration: Float = 0.2,
                         ringThickness: Float = 0.45,
                         intensity: Float = 0.15) -> some View {
        modifier(RippleModifier(speed: speed, aberration: aberration, ringThickness: ringThickness, intensity: intensity))
    }
}

#Preview {
    @Previewable @State var speed: Float = 1.0
    @Previewable @State var aberration: Float = 0.2
    @Previewable @State var thickness: Float = 0.45
    @Previewable @State var intensity: Float = 0.15
    
    Image("test", bundle: .module)
        .resizable().scaledToFit()
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .rippling(speed: speed, aberration: aberration, ringThickness: thickness, intensity: intensity)
        .safeAreaInset(edge: .bottom, spacing: .zero) {
            Grid(horizontalSpacing: 16, verticalSpacing: 8) {
                Group {
                    GridRow {
                        Text("Speed: \(speed.formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $speed, in: 0.5...2.5)
                    }
                    GridRow {
                        Text("Aberration: \(aberration.formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $aberration, in: 0...1)
                    }
                    GridRow {
                        Text("Thickness: \(thickness.formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $thickness, in: 0...1)
                    }
                    GridRow {
                        Text("Intensity: \(intensity.formatted(.number.precision(.fractionLength(2))))")
                        Slider(value: $intensity, in: 0...1)
                    }
                }
                .gridColumnAlignment(.leading)
            }
            .padding(16)
        }
}
