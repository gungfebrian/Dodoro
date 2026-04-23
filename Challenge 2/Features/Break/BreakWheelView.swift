import SwiftUI

struct BreakWheelView: View {
    private let segments = WheelData.breakSegments
    private var segmentAngle: Double { WheelData.segmentAngle(for: segments) }

    @EnvironmentObject var vm: AppViewModel
    @State private var rotation: Double = 0
    @State private var isSpinning = false
    @State private var result: Int? = nil
    @State private var isTransitioned = false

    var body: some View {
        ZStack {
            PaperBackground()

            header
            wheel
            resultDisplay

            // Coin badge (top-right)
            VStack {
                HStack {
                    Spacer()
                    CoinBadge()
                        .padding(.trailing, Layout.screenPadding)
                        .padding(.top, Layout.topBarPadding)
                }
                Spacer()
            }
        }
        .onAppear { handleAppear() }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacing: 6) {
            Text("let's have a")
                .font(AppFont.subtitle)
                .foregroundStyle(AppColor.inkSoft)

            Text("Break\nTime")
                .font(AppFont.heroTitle)
                .foregroundStyle(AppColor.ink)
                .multilineTextAlignment(.center)
                .lineSpacing(-2)

            Text("Spin the wheel to set your\nbreak time.")
                .font(AppFont.caption)
                .foregroundStyle(AppColor.inkMute)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding()
        .offset(y: isTransitioned ? Layout.headerHiddenOffset : Layout.headerOffset)
        .opacity(isTransitioned ? 0 : 1)
    }

    private var wheel: some View {
        VStack {
            ZStack {
                Image("breakWheel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.wheelSize, height: Layout.wheelSize)
                    .rotationEffect(.degrees(rotation))
                    .onTapGesture { spinWheel() }
                    .allowsHitTesting(!isSpinning && result == nil)

                WheelPointer()
            }
        }
        .offset(y: 140)
        .offset(y: isTransitioned ? Layout.wheelHiddenOffset : Layout.wheelBaseOffset)
    }

    @ViewBuilder
    private var resultDisplay: some View {
        if let result {
            Text(String(format: "%02d:00", result))
                .font(.system(size: 72, weight: .heavy, design: .rounded))
                .foregroundColor(isTransitioned ? AppColor.ink : .primary)
                .scaleEffect(isTransitioned ? 1.0 : 0.45)
                .offset(y: Layout.timerDisplayOffset)
                .opacity(isSpinning ? 0 : 1)
        }
    }

    // MARK: - Logic

    private func handleAppear() {
        isSpinning = false
        if vm.needsReverseAnimation {
            vm.needsReverseAnimation = false
            isTransitioned = true
            DispatchQueue.main.asyncAfter(deadline: .now() + Timing.reverseDelay) {
                withAnimation(.easeInOut(duration: Timing.reverseDuration)) {
                    isTransitioned = false
                    result = nil
                    rotation = 0
                }
            }
        }
    }

    private func spinWheel() {
        guard !isSpinning else { return }
        isSpinning = true
        result = nil

        let randomIndex = Int.random(in: 0..<segments.count)
        let targetAngle = Double(randomIndex) * segmentAngle
        let fakeSpins = Double(Int.random(in: 5...8)) * 360.0

        withAnimation(.easeOut(duration: Timing.spinDuration)) {
            rotation = fakeSpins - targetAngle
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Timing.spinDuration) {
            result = segments[randomIndex]
            isSpinning = false
            rotation = rotation.truncatingRemainder(dividingBy: 360)

            DispatchQueue.main.asyncAfter(deadline: .now() + Timing.postSpinDelay) {
                startTransition()
            }
        }
    }

    private func startTransition() {
        withAnimation(.easeInOut(duration: Timing.transitionDuration)) {
            isTransitioned = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Timing.transitionDelay) {
            if let minutes = result {
                vm.breakDuration = minutes
                vm.startBreak()
            }
        }
    }
}

#Preview {
    BreakWheelView()
        .environmentObject(AppViewModel.preview(coins: 15))
}
