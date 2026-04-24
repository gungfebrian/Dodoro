//
//  Vibration test.swift
//  Challenge 2
//
//  Created by Gung  on 24/04/26.
//

import SwiftUI



class Menggetar {
    static let instance = Menggetar()
    
    func notifGetar(notif: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(notif)
    }
    
    func Getar(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
        
    }
}


struct Vibration_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10){
            Text("hello world")
            Button("Test1") {Menggetar.instance.Getar(style: .light)}
            Button("Test2") {Menggetar.instance.Getar(style: .medium)}
            Button("Test3") {Menggetar.instance.Getar(style: .heavy)}
            Button("Test4") {Menggetar.instance.Getar(style: .rigid)}
            Button("Test5") {Menggetar.instance.notifGetar(notif: .success)}
            Button("Test6") {Menggetar.instance.notifGetar(notif: .error)}
            
            
        }
    }
}

