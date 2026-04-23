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
        ShopItem(id: "dodit", name: "Dodit", price: 15, imageName: "Dodit"),
        ShopItem(id: "scribi", name: "Scribi", price: 25, imageName: "Scribi"),
    ]
}
