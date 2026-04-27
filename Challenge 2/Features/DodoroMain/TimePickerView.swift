import SwiftUI

struct TimePickerView: View {
    @EnvironmentObject var vm: AppViewModel
    
    @State private var pickedMinutes: Int = 25

    private let minuteOptions = stride(from: 5, through: 180, by: 5).map { $0 }

    private var totalMinutes: Int { pickedMinutes }

    private var formattedTime: String {
        if pickedMinutes >= 60 {
            let h = pickedMinutes / 60
            let m = pickedMinutes % 60
            return m > 0 ? "\(h)h \(m)m" : "\(h)h"
        }
        return "\(pickedMinutes)m"
    }
    
    // Rough estimate of coins earned — shows the reward loop at decision time.
    private var estimatedCoins: Int {
        max(1, totalMinutes / 5)
    }
    
    // Use shared palette from Theme.swift
    private var ink: Color { AppColor.ink }
    private var inkSoft: Color { AppColor.inkSoft }
    private var inkMute: Color { AppColor.inkMute }
    private var paperHi: Color { AppColor.paperHi }
    private var paperLo: Color { AppColor.paperLo }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 110)
            
            // Header
            header
            
            Spacer().frame(height: 28)
    
            
            Spacer().frame(height: 22)
            
            // Picker box (minutes)
            pickerBox(label: "MINUTES") {
                Picker("Minutes", selection: $pickedMinutes) {
                    ForEach(minuteOptions, id: \.self) { m in
                        Text(formattedPickerRow(m))
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .foregroundStyle(ink)
                            .tag(m)
                    }
                } 
                .pickerStyle(.wheel)
                .frame(height: 160)
                .clipped()
            }
            .padding(.horizontal, 48)
            
            Spacer()
            
            // Reward hint (shows what you'll earn)
            rewardHint
                .padding(.bottom, 14)
            
            // Start button
            startButton
                .padding(.horizontal, 32)
                .padding(.bottom, 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // 1. Cleaner background hierarchy
        .background { PaperBackground() }
        // 2. Cleaner overlay hierarchy for the top bar
        .overlay(alignment: .top) {
            topBar
        }
    }
    
    // MARK: Top Bar Layout
    
    private var topBar: some View {
        HStack(alignment: .top) {
            shopButton
            Spacer()
            modeToggle
                .padding(.top, 4) // Visual alignment nudge
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                coinBadge
            }
        }
        .padding(.horizontal, 20)
        // Using safe area padding handles different notch/island sizes dynamically
        .padding(.top, 16)
    }
    
    // MARK: Header
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Focus Time")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
                .multilineTextAlignment(.center)
            
    
        }
    }
    
    
    // MARK: Picker box
    
    private func pickerBox<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 5) {
                Circle()
                    .fill(inkMute.opacity(0.6))
                    .frame(width: 4, height: 4)
                Text(label)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(inkMute)
                    .tracking(2)
                Circle()
                    .fill(inkMute.opacity(0.6))
                    .frame(width: 4, height: 4)
            }
            .padding(.top, 10)
            
            content()
                .padding(.bottom, 6)
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                // Base paper card
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [paperHi, Color.white.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Inner highlight (top)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
                    .blur(radius: 0.5)
                    .mask(
                        LinearGradient(
                            colors: [.black, .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                
                // Outer sketched border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(paperLo, lineWidth: 1.4)
                
                // Tiny corner doodle marks
                cornerTicks
            }
        )
        .shadow(color: ink.opacity(0.08), radius: 8, x: 0, y: 3)
        .shadow(color: ink.opacity(0.04), radius: 1, x: 0, y: 1)
    }
    
    private var cornerTicks: some View {
        GeometryReader { geo in
            let inset: CGFloat = 8
            let len: CGFloat = 6
            Path { p in
                // top-left
                p.move(to: CGPoint(x: inset, y: inset + len))
                p.addLine(to: CGPoint(x: inset, y: inset))
                p.addLine(to: CGPoint(x: inset + len, y: inset))
                // top-right
                p.move(to: CGPoint(x: geo.size.width - inset - len, y: inset))
                p.addLine(to: CGPoint(x: geo.size.width - inset, y: inset))
                p.addLine(to: CGPoint(x: geo.size.width - inset, y: inset + len))
                // bottom-left
                p.move(to: CGPoint(x: inset, y: geo.size.height - inset - len))
                p.addLine(to: CGPoint(x: inset, y: geo.size.height - inset))
                p.addLine(to: CGPoint(x: inset + len, y: geo.size.height - inset))
                // bottom-right
                p.move(to: CGPoint(x: geo.size.width - inset - len, y: geo.size.height - inset))
                p.addLine(to: CGPoint(x: geo.size.width - inset, y: geo.size.height - inset))
                p.addLine(to: CGPoint(x: geo.size.width - inset, y: geo.size.height - inset - len))
            }
            .stroke(inkMute.opacity(0.35), style: StrokeStyle(lineWidth: 1, lineCap: .round))
        }
    }
    
    private func formattedPickerRow(_ minutes: Int) -> String {
                return "\(minutes)"
    }
    
    // MARK: Reward hint
    
    private var rewardHint: some View {
        HStack(spacing: 6) {
            Image(systemName: "fish.fill")
                .font(.system(size: 12, weight: .semibold))
            Text("Earn ~\(estimatedCoins) coins")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(inkSoft)
        .opacity(totalMinutes > 0 ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: totalMinutes)
    }
    
    // MARK: Start button
    
    private var startButton: some View {
        Button {
            vm.focusDuration = totalMinutes
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
                ZStack {
                    if totalMinutes > 0 {
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
                        // Top inner gloss
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            .blur(radius: 0.4)
                            .mask(
                                LinearGradient(
                                    colors: [.black, .clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                inkMute.opacity(0.6),
                                style: StrokeStyle(lineWidth: 1.4, dash: [4, 4])
                            )
                    }
                }
            )
            .shadow(
                color: totalMinutes > 0 ? ink.opacity(0.25) : .clear,
                radius: 12, x: 0, y: 6
            )
        }
        .disabled(totalMinutes == 0)
        .animation(.easeInOut(duration: 0.2), value: totalMinutes)
    }
    
    // MARK: Top bar 
    
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
        } .offset(x: 15)
    }
    
    private var shopButton: some View {
        ShopButton()
    }
    
    private var coinBadge: some View {
        CoinBadge()
    }
}

#Preview {
    TimePickerView()
        .environmentObject(AppViewModel.preview(coins: 18))
}
