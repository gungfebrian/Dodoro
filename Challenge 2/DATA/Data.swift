//
//  Data.swift
//  Challenge 2
//
//  Created by Gung  on 20/04/26.
//

import SwiftUI
 
struct WheelSegment: Identifiable {
    let id = UUID()
    let label: String
    let minutes: Int
}
 
let segments: [WheelSegment] = [
    WheelSegment(label: "5",  minutes: 5),
    WheelSegment(label: "10", minutes: 10),
    WheelSegment(label: "15", minutes: 15),
    WheelSegment(label: "20", minutes: 20),
    WheelSegment(label: "25", minutes: 25),
    WheelSegment(label: "30", minutes: 30),
    WheelSegment(label: "45", minutes: 45),
    WheelSegment(label: "60", minutes: 60),
]
 
let colorA = Color(red: 0.55, green: 0.72, blue: 0.80)
let colorB = Color(red: 0.44, green: 0.62, blue: 0.72)
let segmentAngle = 360.0 / Double(segments.count) //ini dibagi 
