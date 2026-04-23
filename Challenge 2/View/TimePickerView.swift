import SwiftUI

struct TimePickerView: View {
    @EnvironmentObject var vm: AppViewModel

    @State private var pickedHours: Int = 0
    @State private var pickedMinutes: Int = 10

    private let hourOptions = Array(0...3)
    private let minuteOptions = stride(from: 0, through: 55, by: 5).map { $0 }

    private var totalMinutes: Int { pickedHours * 60 + pickedMinutes }

    private var formattedTime: String {
        if pickedHours > 0 && pickedMinutes > 0 {
            return "\(pickedHours)h \(pickedMinutes)m"
        } else if pickedHours > 0 {
            return "\(pickedHours)h"
        } else {
            return "\(pickedMinutes)m"
        }
    }

    var body: some View {
        ZStack {
            // Paper background
            Image("titikkertas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 100)

                // Header
                VStack(spacing: 6) {
                    Text("Pick your")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.35))

                    Text("Focus\nTime")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(white: 0.10))
                        .multilineTextAlignment(.center)
                        .lineSpacing(-2)

                    Text("Set how long you want\nto stay focused.")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Color(white: 0.50))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }

                Spacer().frame(height: 40)

                // Picker boxes
                HStack(spacing: 12) {
                    // Hour box
                    pickerBox(label: "HOUR") {
                        Picker("Hours", selection: $pickedHours) {
                            ForEach(hourOptions, id: \.self) { h in
                                Text("\(h)")
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .tag(h)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 140)
                        .clipped()
                    }

                    // Colon
                    Text(":")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(white: 0.25))
                        .offset(y: 10)

                    // Minute box
                    pickerBox(label: "MIN") {
                        Picker("Minutes", selection: $pickedMinutes) {
                            ForEach(minuteOptions, id: \.self) { m in
                                Text(String(format: "%02d", m))
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .tag(m)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 140)
                        .clipped()
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                // Start button
                Button {
                    vm.focusDuration = totalMinutes
                    vm.startFocus()
                } label: {
                    Text("Start \(formattedTime)")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(totalMinutes > 0 ? Color(white: 0.12) : Color(white: 0.65))
                        )
                }
                .disabled(totalMinutes == 0)
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }

            // Top bar: mode toggle + shop + coins
            VStack {
                HStack {
                    shopButton
                    Spacer()
                    modeToggle
                    Spacer()
                    coinBadge
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                Spacer()
            }
        }
    }

    // MARK: - Subviews

    private func pickerBox<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(white: 0.45))
                .tracking(1.5)

            content()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.6))
                .strokeBorder(Color(white: 0.82), lineWidth: 1.5)
        )
    }

    private var modeToggle: some View {
        Button {
            vm.preferManualPick = false
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "dice")
                    .font(.system(size: 14, weight: .medium))
                Text("Random")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
            .foregroundStyle(Color(white: 0.30))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.5))
                    .strokeBorder(Color(white: 0.80), lineWidth: 1)
            )
        }
    }

    private var shopButton: some View {
        Button {
            vm.phase = .shop
        } label: {
            Image(systemName: "cart.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color(white: 0.12))
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
        }
    }

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
}

#Preview {
    TimePickerView()
        .environmentObject(AppViewModel.preview(coins: 18))
}
