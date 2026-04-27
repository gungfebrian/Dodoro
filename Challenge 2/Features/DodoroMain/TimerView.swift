import SwiftUI

struct TimerView: View {
    let totalMinutes: Int
    @EnvironmentObject var vm: AppViewModel

    @State private var timeRemaining: Int
    @State private var isRunning = true
    @State private var isHolding = false
    @State private var holdProgress: Double = 0

    private let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
        .onReceive(countdown) { _ in
            guard isRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isRunning = false
                vm.earnCoins(for: totalMinutes)
                Suara.instance.focusDone()
                DispatchQueue.main.asyncAfter(deadline: .now() + Timing.phaseChangeDelay) {
                    vm.phase = .breakSpinning
                }
            }
        }
        .gesture(HoldToExitBar.gesture(isHolding: $isHolding, holdProgress: $holdProgress, onExit: exit))
        .onChange(of: isHolding) { _, newValue in
            if newValue { Menggetar.instance.Getar(style: .medium) }
        }
    }

    private func exit() {
        isRunning = false
        vm.forfeitCoins(5)
        Menggetar.instance.notifGetar(notif: .warning)
        Suara.instance.forfeit()
        vm.resetToSpin()
    }
}

#Preview {
    TimerView(totalMinutes: 1)
        .environmentObject(AppViewModel.preview(coins: 8))
}
