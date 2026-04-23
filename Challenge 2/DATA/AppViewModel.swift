import SwiftUI
import Combine

// MARK: - App Phase

enum AppPhase: Equatable {
    case spinning, focusing, breakSpinning, onBreak, shop
}

// MARK: - App View Model

class AppViewModel: ObservableObject {

    // Navigation
    @Published var phase: AppPhase = .spinning

    // Timer durations (minutes)
    @Published var focusDuration: Int = 0
    @Published var breakDuration: Int = 0

    // Economy
    @Published var coins: Int = 0
    @Published var ownedItems: Set<String> = []

    // First-spin flag — after first spin, manual time picker unlocks
    @Published var hasSpunOnce: Bool = false

    // MARK: - Init (load persisted data)

    init() {
        let defaults = UserDefaults.standard
        coins = defaults.integer(forKey: "coins")
        ownedItems = Set(defaults.stringArray(forKey: "ownedItems") ?? [])
        hasSpunOnce = defaults.bool(forKey: "hasSpunOnce")
    }

    // MARK: - Phase Transitions

    func startFocus() {
        phase = .focusing
    }

    func startBreak() {
        phase = .onBreak
    }

    func resetToSpin() {
        phase = .spinning
    }

    // MARK: - Economy

    func earnCoins(for minutes: Int) {
        coins += minutes
        save()
    }

    func purchase(item: ShopItem) -> Bool {
        guard coins >= item.price, !ownedItems.contains(item.id) else { return false }
        coins -= item.price
        ownedItems.insert(item.id)
        save()
        return true
    }

    func owns(_ item: ShopItem) -> Bool {
        ownedItems.contains(item.id)
    }

    // MARK: - Persistence

    func markFirstSpin() {
        hasSpunOnce = true
        UserDefaults.standard.set(true, forKey: "hasSpunOnce")
    }

    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(coins, forKey: "coins")
        defaults.set(Array(ownedItems), forKey: "ownedItems")
    }
}
