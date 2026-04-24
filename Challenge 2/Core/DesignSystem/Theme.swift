import SwiftUI

//MARK: theme color
enum AppColor {
    static let ink      = Color(red: 0.14, green: 0.12, blue: 0.10)
    static let inkSoft  = Color(red: 0.34, green: 0.30, blue: 0.26)
    static let inkMute  = Color(red: 0.55, green: 0.50, blue: 0.44)
    static let paperHi  = Color(red: 1.00, green: 0.99, blue: 0.96)
    static let paperLo  = Color(red: 0.92, green: 0.88, blue: 0.80)
}

//MARK: Layout
enum Layout {
    static let screenPadding: CGFloat = 24
    static let topBarPadding: CGFloat = 60
    static let wheelSize: CGFloat = 600
    static let pointerSize: CGFloat = 124
    static let pointerOffset: CGFloat = -270
    static let wheelBaseOffset: CGFloat = 280
    static let wheelHiddenOffset: CGFloat = 800
    static let headerOffset: CGFloat = -220
    static let headerHiddenOffset: CGFloat = -500
    static let timerDisplayOffset: CGFloat = -40
    static let holdBarWidth: CGFloat = 120
    static let holdBarHeight: CGFloat = 3
}

//MARK: Animation Time
enum Timing {
    static let spinDuration: Double = 4.0
    static let postSpinDelay: Double = 1.0
    static let transitionDuration: Double = 0.9
    static let transitionDelay: Double = 0.8
    static let reverseDuration: Double = 0.7
    static let reverseDelay: Double = 0.05
    static let holdDuration: Double = 1.5
    static let phaseChangeDelay: Double = 0.8
}

// MARK: - App Fonts

enum AppFont {
    static let timerDisplay = Font.system(size: 72, weight: .heavy, design: .rounded)
    static let heroTitle = Font.system(size: 60, weight: .bold, design: .rounded)
    static let subtitle = Font.system(size: 20, weight: .medium, design: .rounded)
    static let caption = Font.system(size: 14, weight: .regular, design: .rounded)
    static let badge = Font.system(size: 18)
    static let badgeText = Font.system(size: 18, weight: .bold, design: .rounded)
}
