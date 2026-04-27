import SwiftUI

struct TimePickerView: View {
    @EnvironmentObject var vm: AppViewModel

    @State private var pickedMinutes: Int = 25

    private let minuteOptions = stride(from: 5, through: 180, by: 5).map { $0 }

    private var formattedTime: String {
        if pickedMinutes >= 60 {
            let h = pickedMinutes / 60
            let m = pickedMinutes % 60
            return m > 0 ? "\(h)h \(m)m" : "\(h)h"
        }
        return "\(pickedMinutes)m"
    }

    private var estimatedCoins: Int {
        max(1, pickedMinutes / 5)
    }

    private var ink: Color { AppColor.ink }
    private var inkSoft: Color { AppColor.inkSoft }
    private var inkMute: Color { AppColor.inkMute }
    private var paperHi: Color { AppColor.paperHi }
    private var paperLo: Color { AppColor.paperLo }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 110)

            Text("Focus Time")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(ink)

            Spacer().frame(height: 32)

            pickerBox(label: "MINUTES") {
                Picker("Minutes", selection: $pickedMinutes) {
                    ForEach(minuteOptions, id: \.self) { m in
                        Text("\(m)")
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .foregroundStyle(ink)
                            .tag(m)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
                .clipped()
            }
            .padding(.horizontal, 32)

            Spacer()
            rewardHint
                .padding(.bottom, 14)

            startButton
                .padding(.horizontal, 32)
                .padding(.bottom, 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { PaperBackground() }
        .overlay(alignment: .top) {
            topBar
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack(alignment: .top) {
            ShopButton()
            Spacer()
            modeToggle
                .padding(.top, 4)
            Spacer()
            CoinBadge()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Subviews

    private func pickerBox<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(inkMute.opacity(0.6))
                    .frame(width: 5, height: 5)
                Text(label)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(inkMute)
                    .tracking(2.5)
                Circle()
                    .fill(inkMute.opacity(0.6))
                    .frame(width: 5, height: 5)
            }
            .padding(.top, 22)

            content()
                .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [paperHi, Color.white.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
                    .blur(radius: 0.5)
                    .mask(
                        LinearGradient(
                            colors: [.black, .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                RoundedRectangle(cornerRadius: 28)
                    .stroke(paperLo, lineWidth: 1.6)
            }
        )
        .shadow(color: ink.opacity(0.10), radius: 14, x: 0, y: 6)
        .shadow(color: ink.opacity(0.04), radius: 1, x: 0, y: 1)
    }

    private var rewardHint: some View {
        HStack(spacing: 6) {
            Image(systemName: "fish.fill")
                .font(.system(size: 12, weight: .semibold))
            Text("Earn ~\(estimatedCoins) coins")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(inkSoft)
        .opacity(pickedMinutes > 0 ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: pickedMinutes)
    }

    private var startButton: some View {
        Button {
            vm.focusDuration = pickedMinutes
            vm.startFocus()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "play.fill")
                    .font(.system(size: 15, weight: .bold))
                Text("Start \(formattedTime)")
                    .font(.system(size: 19, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.20, green: 0.17, blue: 0.14),
                                Color(red: 0.10, green: 0.08, blue: 0.06)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .shadow(color: ink.opacity(0.25), radius: 12, x: 0, y: 6)
        }
    }

    private var modeToggle: some View {
        Button {
            vm.preferManualPick = false
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "dice.fill")
                    .font(.system(size: 13, weight: .semibold))
                Text("Random")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(ink)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    Capsule()
                        .fill(Color.white.opacity(0.7))
                    Capsule()
                        .stroke(paperLo, lineWidth: 1)
                }
            )
            .shadow(color: ink.opacity(0.06), radius: 3, x: 0, y: 2)
        }
    }
}

#Preview {
    TimePickerView()
        .environmentObject(AppViewModel.preview(coins: 18))
}
