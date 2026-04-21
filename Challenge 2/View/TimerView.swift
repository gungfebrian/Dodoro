import SwiftUI

struct TimerView: View {

    let totalMinutes: Int
    @Binding var isPresented: Bool // binding

    @State private var timeRemaining: Int
    @State private var isHolding = false
    @State private var holdProgress: Double = 0

  //init binding dari @enviroment balik
    init(totalMinutes: Int, isPresented: Binding<Bool>) {
        self.totalMinutes = totalMinutes
        self._isPresented = isPresented
        self._timeRemaining = State(initialValue: totalMinutes * 60)
        // contoh 7*60 = 370 = 7 menit
    }

    var formattedTime: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    } //420/60 = 7, modulo untuk detik
    var body: some View {
        ZStack {
            Image("titikkertas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text(formattedTime)
                    .font(.system(size: 72))
                    .fontWeight(.heavy)
                    .fontDesign(.rounded)
                    .foregroundColor(Color(white: 0.12))
                
                if timeRemaining == 0 {
                    Text("Done!")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }       .offset(y: -40) //spacer gati ini supaya sama kaya main
            
            VStack {
                Spacer() //vstack spacer manual dorong
                
                VStack(spacing: 12) {
                    
                    
                    Text("Hold to exit")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .foregroundColor(.gray.opacity(0.6))
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 3)
                            .opacity(isHolding ? 1 : 0)
                        
                        if isHolding {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(white: 0.18))
                                .frame(width: 120 * holdProgress, height: 3)
                        }
                    }
                    .frame(width: 120, height: 3)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear { startCountdown() }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !isHolding else { return }
                    isHolding = true
                    holdProgress = 0
                    withAnimation(.linear(duration: 1.5)) { holdProgress = 1.0 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        guard isHolding else { return }
                        isPresented = false // 3. Changed dismiss() to isPresented = false
                    }
                }
                .onEnded { _ in
                    isHolding = false
                    holdProgress = 0
                }
        )
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                t.invalidate()
            }
        }
    }
}

#Preview {
    //hardcode untuk test
    TimerView(totalMinutes: 25, isPresented: .constant(true))
}
