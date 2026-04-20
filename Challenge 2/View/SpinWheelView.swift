//
//  WheelSpin.swift
//  AlarmAppDemo
//
//  Created by Alan Brian Frederick on 19/04/26.
//

import SwiftUI
import AVKit

struct SpinWheelView: View {
    static let segments: [Int] = [5, 6, 7, 8, 9, 10, 12, 15]
    let segmentAngle: Double = 360.0 / Double(Self.segments.count)
    
    @State private var rotation: Double = 0
    @State private var isSpinning: Bool = false
    @State private var result: Int? = nil
    @State private var Ztimer: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("titikkertas")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        Text("let the cat")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("decide.")
                            .font(.system(size: 64))
                            .fontWeight(.bold)
                        
                        Text("Spin the wheel to set your\nfirst focus session.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    } .padding()
                    
                    
                    
                    VStack(spacing: 0) {
                        
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
                            
                            if let result {
                                Text("\(result) minutes")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .transition(.scale.combined(with: .opacity))
                                    .offset(y: -370)
                            }
                            
                            if let result, !isSpinning {
                                Button(action: { Ztimer = true }) {
                                    Text("Start Timer →")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12).fill(Color.gray)
                                        )
                                }
                                .padding(.top, 8)
                                .transition(.opacity)
                                
                            }
                            
                        }.offset(y: 280)
                        
                            .navigationDestination(isPresented: $Ztimer) {
                                if let minutes = result {
                                    TimerView(totalMinutes: minutes) }}
                    }
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
        }
    }
}

#Preview {
    SpinWheelView()
}

