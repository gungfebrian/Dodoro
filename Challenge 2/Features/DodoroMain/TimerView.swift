import SwiftUI

struct TimerView: View {
    let totalMinutes: Int
    @EnvironmentObject var vm: AppViewModel

    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var isHolding = false
    @State private var holdProgress: Double = 0

    init(totalMinutes: Int) {
        self.totalMinutes = totalMinutes
        self._timeRemaining = State(initialValue: totalMinutes * 60)
    }

    var body: some View {
        ZStack {
            PaperBackground()

            TimerDisplay(time: formatTime(timeRemaining))

            VStack {
                Spacer()
                HoldToExitBar(isHolding: $isHolding, holdProgress: $holdProgress, onExit: exit)
                    .padding(.bottom, 40)
            }

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
        .onAppear { startCountdown() }
        .onDisappear { stopTimer() }
        .gesture(HoldToExitBar.gesture(isHolding: $isHolding, holdProgress: $holdProgress, onExit: exit))
    }

    // MARK: - Actions

    private func exit() {
        stopTimer()
        vm.resetToSpin()
    }

    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                t.invalidate()
                timer = nil
                vm.earnCoins(for: totalMinutes)
                DispatchQueue.main.asyncAfter(deadline: .now() + Timing.phaseChangeDelay) {
                    vm.phase = .breakSpinning
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    TimerView(totalMinutes: 1)
        .environmentObject(AppViewModel.preview(coins: 8))
}
