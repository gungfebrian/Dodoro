# Pomodoro App — Architecture Overhaul & Coin System

## New File

### `Challenge 2/Challenge 2/DATA/AppViewModel.swift`
The single source of truth for the entire app.

- `AppPhase` enum — controls which screen is shown
- `AppViewModel` class — holds all shared state, injected via `.environmentObject()`

#### Properties

| Property       | Type          | Purpose                                                              |
|----------------|---------------|----------------------------------------------------------------------|
| phase          | AppPhase      | Which screen is active (.spinning, .focusing, .breakSpinning, .onBreak, .shop) |
| focusDuration  | Int           | Minutes chosen by spin wheel or manual picker                        |
| breakDuration  | Int           | Minutes chosen by break wheel                                        |
| coins          | Int           | Currency earned after focus sessions, persisted in UserDefaults       |
| ownedItems     | Set\<String\> | IDs of purchased shop items, persisted in UserDefaults                |
| hasSpunOnce    | Bool          | Unlocks manual time picker after first spin, persisted               |

#### Methods

| Method                              | What it does                                                         |
|-------------------------------------|----------------------------------------------------------------------|
| startFocus()                        | Sets phase to .focusing                                              |
| startBreak()                        | Sets phase to .onBreak                                               |
| resetToSpin()                       | Sets phase to .spinning                                              |
| earnCoins(for:)                     | Adds 1 coin per focus minute completed, saves to UserDefaults        |
| purchase(item:)                     | Deducts price from coins, adds item ID to ownedItems, returns Bool   |
| owns(_:)                            | Checks if an item is already purchased                               |
| markFirstSpin()                     | Sets hasSpunOnce = true, persists it                                 |
| preview(coins:owned:hasSpunOnce:)   | Static helper — creates a pre-configured VM for Canvas previews      |

---

## Modified Files

### `Challenge 2/Challenge 2/DATA/Data.swift` — Centralized data models

- WheelData.focusSegments = [5, 6, 7, 8, 9, 10, 12, 15] (was scattered in each view as static let segments)
- WheelData.breakSegments = [1, 2, 3, 4, 5] (was [0] — a zero-minute break)
- WheelData.segmentAngle(for:) — calculates angle per segment
- NEW: ShopItem struct with id, name, price, imageName and static let allItems (Dodit at 15 coins, Scribi at 25 coins)

---

### `Challenge 2/Challenge 2/DATA/ContentView.swift` — Phase-based router

- Switches on vm.phase to show the correct screen
- Each case has .transition(.opacity) for smooth crossfade
- .animation(.easeInOut(duration: 0.5), value: vm.phase) animates all transitions
- This replaced the old approach where views were stacked on top of each other with @Binding var isPresented

---

### `Challenge 2/Challenge 2/DATA/Challenge_2App.swift` — App entry point

- Creates @StateObject private var vm = AppViewModel()
- Injects via .environmentObject(vm) into ContentView
- Removed NavigationStack wrapper (no longer needed — ContentView handles routing)

---

### `Challenge 2/Challenge 2/View/SpinWheelView.swift` — Focus wheel

What changed:
- REMOVED: showTimer, showBreakWheel booleans and their onChange handlers
- REMOVED: Internal TimerView() and BreakWheelView() overlays (ContentView handles this now)
- ADDED: @EnvironmentObject var vm: AppViewModel
- ADDED: Shop button (cart icon, top-left) — sets vm.phase = .shop
- ADDED: Coin badge (star + count, top-right) showing current coins
- ADDED: Manual time picker — appears as "or pick your time" link after first spin, opens a grid overlay to tap-select duration
- CHANGED: Uses WheelData.focusSegments instead of local static let segments
- CHANGED: startTransitionSequence() now sets vm.focusDuration and calls vm.startFocus() instead of toggling showTimer

---

### `Challenge 2/Challenge 2/View/TimerView.swift` — Focus countdown

What changed:
- REMOVED: @Binding var isPresented, onTimerEnd closure, complex init with bindings
- ADDED: @EnvironmentObject var vm: AppViewModel
- ADDED: Coin badge (top-right) showing current coins
- FIXED: Countdown decrement from timeRemaining -= 50 to timeRemaining -= 1 (was a debug speedup)
- ADDED: vm.earnCoins(for: totalMinutes) call when timer hits 0 — this is where coins are earned
- CHANGED: On timer complete — vm.phase = .breakSpinning. On hold-to-exit — vm.resetToSpin()
- REFACTORED: Extracted coinBadge, holdToExitBar, holdGesture as computed properties for readability

---

### `Challenge 2/Challenge 2/View/ShopView.swift` — Item shop

What changed:
- REMOVED: @State private var money: Int = 24 (hardcoded local state)
- ADDED: @EnvironmentObject var vm: AppViewModel — reads vm.coins for real balance
- ADDED: Back button (chevron-left) — calls vm.resetToSpin()
- ADDED: Coin badge in header showing live coin count
- ADDED: Dynamic item cards using ForEach(ShopItem.allItems) — shows price button or "Owned" badge
- ADDED: Purchase logic via vm.purchase(item:) — deducts coins, marks as owned
- ADDED: Purchase feedback toast — "You got [name]!" with spring animation
- ADDED: Disabled state on buy button when you can't afford an item (grayed out)
- ADDED: Green border on owned item cards

---

### `Challenge 2/BreakView/BreakWheelView.swift` — Break wheel

What changed:
- REMOVED: @Binding var isPresented, isDone, showBreakTimer and their onChange handlers
- REMOVED: Internal BreakTimerView() overlay
- FIXED: Segments from [0] to WheelData.breakSegments = [1, 2, 3, 4, 5] minutes
- ADDED: @EnvironmentObject var vm: AppViewModel
- ADDED: Coin badge (top-right)
- CHANGED: startTransitionSequence() now sets vm.breakDuration and calls vm.startBreak()

---

### `Challenge 2/BreakView/BreakTimerView.swift` — Break countdown

What changed:
- REMOVED: @Binding var isPresented, onTimerEnd closure
- REMOVED: Inline SpinWheelView() that appeared when timer hit 0
- ADDED: @EnvironmentObject var vm: AppViewModel
- CHANGED: On timer complete — vm.resetToSpin(). On hold-to-exit — vm.resetToSpin()
- Countdown was already -1 per second (correct)

---

## App Flow (before vs after)

BEFORE: Each view managed its own navigation with @Binding var isPresented and internal overlays. Views were stacked on top of each other. No shared state.

AFTER:

    ContentView (router)
      |-- .spinning      --> SpinWheelView
      |-- .focusing      --> TimerView        <-- earns coins here
      |-- .breakSpinning --> BreakWheelView
      |-- .onBreak       --> BreakTimerView
      |-- .shop          --> ShopView

All navigation happens by setting vm.phase. All views read from the same AppViewModel via @EnvironmentObject.

---

## Coin Economy

    Focus session completes (e.g. 10 min) --> +10 coins
    Shop: Dodit costs 15, Scribi costs 25
    Coins + purchases persist across app launches (UserDefaults)
