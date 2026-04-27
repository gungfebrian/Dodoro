import Foundation

struct WheelData {
    static let focusSegments: [Int] = [5, 6, 7, 8, 9, 10, 12, 15]
    static let breakSegments: [Int] = [1, 2, 3, 4, 5]

    static func segmentAngle(for segments: [Int]) -> Double {
        360.0 / Double(segments.count)
    }
}

struct ShopItem: Identifiable, Equatable {
    let id: String
    let name: String
    let price: Int
    let imageName: String

    static let allItems: [ShopItem] = [
        ShopItem(id: "DefaultPointer", name: "Default", price: 0, imageName: "Pointer"),
        ShopItem(id: "Pointer", name: "Paper Clip", price: 15, imageName: "Pointer"),
        ShopItem(id: "PointerPencil", name: "Pencil", price: 25, imageName: "PointerPencil"),
        ShopItem(id: "PointerPin", name: "Pin", price: 25, imageName: "PointerPin"),
        ShopItem(id: "PointerRuler", name: "Ruler", price: 35, imageName: "PointerRuler"),
        ShopItem(id: "PointerCompass", name: "Compass", price: 50, imageName: "PointerCompass"),
        ShopItem(id: "PointerScissors", name: "Scissors", price: 55, imageName: "PointerScissors"),
        ShopItem(id: "scribi5", name: "Scribi2", price: 25, imageName: "Scribi"),
        ShopItem(id: "scribi6", name: "Scribi2", price: 25, imageName: "Scribi"),
        ShopItem(id: "scribi7", name: "Scribi2", price: 25, imageName: "Scribi"),

    ]
}

//MARK: Data shop, segment, ETC
