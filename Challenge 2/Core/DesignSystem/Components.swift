import SwiftUI


 // MARK: test
// TODO: test
// FIXME: test

//MARK: background
struct PaperBackground: View {
    var body: some View {
        Image("titikkertas")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}


//MARK: Coin di main
struct CoinBadge: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "fish.circle.fill")
                .foregroundStyle(.yellow)
            Text("\(vm.coins)")
                .font(AppFont.badgeText)
        }
        .font(AppFont.badge)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

//MARK: Shop button
struct ShopButton: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        Button {
            vm.phase = .shop
            
            Menggetar.instance.Getar(style: .heavy) ////fuysgefyugsefesfg
            
        } label: {
            Image(systemName: "cart.fill")
                .font(.system(size: 18))
                .foregroundStyle(AppColor.ink)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
        }
    }
}

//MARK: Hold to exit button
struct HoldToExitBar: View {
    @Binding var isHolding: Bool
    @Binding var holdProgress: Double
    var onExit: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Hold to exit")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.gray.opacity(0.6))

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: Layout.holdBarWidth, height: Layout.holdBarHeight)
                    .opacity(isHolding ? 1 : 0)

                if isHolding {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColor.ink)
                        .frame(width: Layout.holdBarWidth * holdProgress, height: Layout.holdBarHeight)
                }
            }
            .frame(width: Layout.holdBarWidth, height: Layout.holdBarHeight)
        }
    }

    static func gesture(isHolding: Binding<Bool>, holdProgress: Binding<Double>, onExit: @escaping () -> Void) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard !isHolding.wrappedValue else { return }
                isHolding.wrappedValue = true
                holdProgress.wrappedValue = 0
                withAnimation(.linear(duration: Timing.holdDuration)) {
                    holdProgress.wrappedValue = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Timing.holdDuration) {
                    guard isHolding.wrappedValue else { return }
                    onExit()
                }
            }
            .onEnded { _ in
                isHolding.wrappedValue = false
                holdProgress.wrappedValue = 0
            }
    }
}

//MARK: Wheel
struct WheelPointer: View {
    var body: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: Layout.pointerSize))
            .foregroundStyle(.white)
            .shadow(color: .black, radius: 5)
            .offset(y: Layout.pointerOffset)
    }
}

//MARK: Timer
struct TimerDisplay: View {
    let time: String

    var body: some View {
        Text(time)
            .font(AppFont.timerDisplay)
            .foregroundColor(AppColor.ink)
            .offset(y: Layout.timerDisplayOffset)
    }
}

// MARK: - Helper: format seconds → "MM:SS"
func formatTime(_ seconds: Int) -> String {
    String(format: "%02d:%02d", seconds / 60, seconds % 60)
}


