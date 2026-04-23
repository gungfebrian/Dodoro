import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        ZStack {
            switch vm.phase {
            case .spinning:
                if vm.hasSpunOnce && vm.preferManualPick {
                    TimePickerView()
                        .transition(.opacity)
                } else {
                    SpinWheelView()
                        .transition(.opacity)
                }
            case .focusing:
                TimerView(totalMinutes: vm.focusDuration)
                    .transition(.opacity)
            case .breakSpinning:
                BreakWheelView()
                    .transition(.opacity)
            case .onBreak:
                BreakTimerView(totalMinutes: vm.breakDuration)
                    .transition(.opacity)
            case .shop:
                ShopView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: vm.phase)
        .animation(.easeInOut(duration: 0.3), value: vm.preferManualPick)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
