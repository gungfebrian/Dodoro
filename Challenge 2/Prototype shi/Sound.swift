import AudioToolbox
import AVFoundation

class Suara {
    static let instance = Suara()

    private var spinResultPlayer: AVAudioPlayer?
    private var holdExitPlayer: AVAudioPlayer?

    private init() {
        if let asset = NSDataAsset(name: "Clicksound") {
            spinResultPlayer = try? AVAudioPlayer(data: asset.data)
            spinResultPlayer?.prepareToPlay()
        }
        if let asset = NSDataAsset(name: "HoldExit") {
            holdExitPlayer = try? AVAudioPlayer(data: asset.data)
            holdExitPlayer?.prepareToPlay()
        }
    }

    // Decelerating wheel ticks
    func tickSpin(duration: Double) {
        var delays: [Double] = []
        var cumulative = 0.0
        var interval = 0.09
        while cumulative < duration - 0.4 {
            delays.append(cumulative)
            cumulative += interval
            interval *= 1.14
        }
        for delay in delays {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                AudioServicesPlaySystemSound(1104)
            }
        }
    }

    // Wheel snaps onto result
    func spinResult() {
        spinResultPlayer?.stop()
        spinResultPlayer?.currentTime = 0
        spinResultPlayer?.play()
    }

    // Hold-to-exit from focus timer
    func holdExit() {
        holdExitPlayer?.stop()
        holdExitPlayer?.currentTime = 0
        holdExitPlayer?.play()
    }

    // Focus session finished — coins earned
    func focusDone() {
        AudioServicesPlaySystemSound(1025)
    }

    // Break session ended — back to work
    func breakDone() {
        AudioServicesPlaySystemSound(1022)
    }

    // Coins spent in the shop
    func purchase() {
        AudioServicesPlaySystemSound(1001)
    }

    // Item equipped
    func equipItem() {
        AudioServicesPlaySystemSound(1103)
    }

    // Early exit — coins forfeited
    func forfeit() {
        AudioServicesPlaySystemSound(1006)
    }
}
