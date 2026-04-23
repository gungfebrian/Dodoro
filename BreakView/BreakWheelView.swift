import SwiftUI

struct BreakWheelView: View {
    private let segments = WheelData.breakSegments
    private var segmentAngle: Double { WheelData.segmentAngle(for: segments) }

    @EnvironmentObject var vm: AppViewModel
    @State private var rotation: Double = 0
    @State private var isSpinning = false
    @State private var result: Int? = nil
    @State private var isAnimasiOn = false

    var body: some View {
        ZStack {
            Image("titikkertas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Header
            VStack {
                Text("let's have a")
                    .font(.title2)
                    .fontWeight(.medium)

                Text("Break\nTime")
                    .font(.system(size: 64))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)

                Text("Spin the wheel to set your\nbreak time.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .offset(y: isAnimasiOn ? -500 : -220)
            .opacity(isAnimasiOn ? 0 : 1)

            // Wheel
            VStack {
                ZStack {
                    Image("breakWheel")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 600, height: 600)
                        .rotationEffect(.degrees(rotation))
                        .onTapGesture { spinWheel() }

                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 124))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 5)
                        .offset(y: -270)
                }
            }
            .offset(y: 140)
            .offset(y: isAnimasiOn ? 800 : 280)

            // Result display
            if let result {
                Text(String(format: "%02d:00", result))
                    .font(.system(size: 72, weight: .heavy, design: .rounded))
                    .foregroundColor(isAnimasiOn ? Color(white: 0.12) : .primary)
                    .scaleEffect(isAnimasiOn ? 1.0 : 0.45)
                    .offset(y: isAnimasiOn ? -40 : -40)
                    .opacity(isSpinning ? 0 : 1)
            }

            // Coin badge (top-right)
            VStack {
                HStack {
                    Spacer()
                    coinBadge
                        .padding(.trailing, 24)
                        .padding(.top, 60)
                }
                Spacer()
            }
        }
    }

    // MARK: - Subviews

    private var coinBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.circle.fill")
                .foregroundStyle(.yellow)
            Text("\(vm.coins)")
                .fontWeight(.bold)
                .fontDesign(.rounded)
        }
        .font(.system(size: 18))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }

    // MARK: - Spin Logic

    func spinWheel() {
        guard !isSpinning else { return }
        isSpinning = true
        result = nil

        let randomIndex = Int.random(in: 0..<segments.count)
        let targetAngle = Double(randomIndex) * segmentAngle
        let fakeSpins = Double(Int.random(in: 5...8)) * 360.0
        let finalRotation = fakeSpins - targetAngle

        withAnimation(.easeOut(duration: 4.0)) {
            rotation = finalRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            result = segments[randomIndex]
            isSpinning = false
            rotation = rotation.truncatingRemainder(dividingBy: 360)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                startTransitionSequence()
            }
        }
    }

    private func startTransitionSequence() {
        withAnimation(.easeInOut(duration: 0.9)) {
            isAnimasiOn = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if let minutes = result {
                vm.breakDuration = minutes
                vm.startBreak()
            }
        }
    }
}

#Preview {
    BreakWheelView()
        .environmentObject(AppViewModel())
}
