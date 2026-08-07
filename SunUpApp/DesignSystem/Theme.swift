import SwiftUI

enum SunUpTheme {
    static let yellow = Color(red: 1, green: 222 / 255, blue: 0)
    static let teal = Color(red: 0, green: 184 / 255, blue: 174 / 255)
    static let background = Color(red: 245 / 255, green: 245 / 255, blue: 247 / 255)
    static let secondaryText = Color.black.opacity(0.58)
    static let cornerRadius: CGFloat = 18
}

extension Font {
    static func sunUpTitle(_ size: CGFloat = 38) -> Font { .system(size: size, weight: .black, design: .rounded) }
}

extension Decimal {
    var aed: String { "\(NSDecimalNumber(decimal: self).stringValue) AED" }
}
