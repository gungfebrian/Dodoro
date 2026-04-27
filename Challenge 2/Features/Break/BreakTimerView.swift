import SwiftUI

struct BreakTimerView: View {
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
                    .padding(.bottom, 60)
            }
        }
        .onReceive(countdown) { _ in
            guard isRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isRunning = false
                Suara.instance.breakDone()
                vm.resetToSpin()
            }
        }
        .gesture(HoldToExitBar.gesture(isHolding: $isHolding, holdProgress: $holdProgress, onExit: exit))
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
    BreakTimerView(totalMinutes: 1)
        .environmentObject(AppViewModel.preview(coins: 15))
}
