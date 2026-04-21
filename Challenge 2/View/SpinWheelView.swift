import SwiftUI
import AVKit

struct SpinWheelView: View {
    static let segments: [Int] = [5, 6, 7, 8, 9, 10, 12, 15]
    let segmentAngle: Double = 360.0 / Double(Self.segments.count)
    
    @State private var rotation: Double = 0
    @State private var isSpinning: Bool = false
    @State private var result: Int? = nil
    
    @State private var isAnimasiOn: Bool = false  //  trantition
    @State private var showTimer: Bool = false //
    
    var body: some View {
        ZStack {
            Image("titikkertas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
    
            VStack {
                Text("Spin your")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Pomodoro\nTimer")
                    .font(.system(size: 64))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    
                
                Text("Spin the wheel to set your\nfirst focus session.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            
            .padding()
            .offset(y: isAnimasiOn ? -500 : -220) //posisi header
            .opacity(isAnimasiOn ? 0 : 1)
            
            VStack{
                
                ZStack {
                    Image("SPINNNN")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 600, height: 600)
                        .rotationEffect(.degrees(rotation))
                        .onTapGesture {
                            spinWheel()
                        }
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 124))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 5)
                        .offset(y: -270)
                }
            }
            .offset(y: 140) //posisi wheel
            .offset(y: isAnimasiOn ? 800 : 280)
            
    
            if let result {
              
                    Text(String(format: "%02d:00", result))
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .foregroundColor(isAnimasiOn ? Color(white: 0.12) : .primary)
                        .scaleEffect(isAnimasiOn ? 1.0 : 0.45)
                        .offset(y: isAnimasiOn ? -40 : -40)
                        .opacity(isSpinning ? 0 : 1)
                
            }
            
            //ini fade header
            if showTimer, let minutes = result {
                TimerView(totalMinutes: minutes, isPresented: $showTimer)
                    .transition(.opacity)
            }
        }
        
        // reset
        .onChange(of: showTimer) { oldValue, newValue in
            if !newValue {
                withAnimation(.easeInOut(duration: 0.7)) {
                    isAnimasiOn = false
                    result = nil
                    rotation = 0
                    
                }
            }
        }
    }
    
    func spinWheel() {
        guard !isSpinning else { return }
        isSpinning = true
        result = nil
        
        let randomIndex = Int.random(in: 0..<Self.segments.count)
        let targetAngle = Double(randomIndex) * segmentAngle
        let fakeSpins = Double(Int.random(in: 5...8)) * 360.0
        let finalRotation = fakeSpins - targetAngle
        
        withAnimation(.easeOut(duration: 4.0)) {
            rotation = finalRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            result = Self.segments[randomIndex]
            isSpinning = false
            rotation = rotation.truncatingRemainder(dividingBy: 360)
            
            // dispatch 1.5 baru animasi
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                startTransitionSequence()
            }
        }
    }
    
    func startTransitionSequence() {
        //wheel kebawah text ke tengah
        withAnimation(.easeInOut(duration: 0.9)) {
            isAnimasiOn = true
        }
        
        // screen 2 fade
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showTimer = true
            }
        }
    }
}

#Preview {
    SpinWheelView()
}

//alan anying
