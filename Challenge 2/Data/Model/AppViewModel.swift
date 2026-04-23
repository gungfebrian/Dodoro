import SwiftUI
import Combine

// MARK: - App Phase

enum AppPhase: Equatable {
    case spinning, focusing, breakSpinning, onBreak, shop
}

// MARK: - App View Model

class AppViewModel: ObservableObject {

    @Published var phase: AppPhase = .spinning

    @Published var focusDuration: Int = 0
    @Published var breakDuration: Int = 0

    // Economy
    @Published var coins: Int = 0
    @Published var ownedItems: Set<String> = []

    // First-spin flag — after first spin, manual time picker unlocks
    @Published var hasSpunOnce: Bool = false

    // Mode toggle: true = manual picker, false = spin wheel (only matters after first spin)
    @Published var preferManualPick: Bool = false

    // When true, wheel views play the reverse transition animation on appear
    var needsReverseAnimation: Bool = false

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
        needsReverseAnimation = true
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

    // MARK: - Preview Helper

    static func preview(coins: Int = 20, owned: [String] = [], hasSpunOnce: Bool = true) -> AppViewModel {
        let vm = AppViewModel()
        vm.coins = coins
        vm.ownedItems = Set(owned)
        vm.hasSpunOnce = hasSpunOnce
        return vm
    }
}
