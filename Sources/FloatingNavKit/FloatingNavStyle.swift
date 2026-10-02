import SwiftUI

public struct FloatingNavStyle {
    public var backgroundColor = Color(red: 3 / 255, green: 3 / 255, blue: 3 / 255)
    public var selectedColor = Color.white
    public var unselectedColor = Color(red: 161 / 255, green: 161 / 255, blue: 161 / 255)
    public var indicatorColor = Color.white.opacity(0.15)

    public var slotSize: CGFloat = 44
    public var iconSize: CGFloat = 24
    public var itemSpacing: CGFloat = 33.5
    public var contentPadding: CGFloat = 12
    public var bottomPadding: CGFloat = 8

    /// Scale applied to the bar while the scroll view is moving.
    public var shrinkScale: CGFloat = 0.8
    /// Seconds to wait after scrolling stops before the bar returns to full size.
    public var restoreDelay: TimeInterval = 0.8
    public var scaleAnimation: Animation = .spring(response: 0.35, dampingFraction: 0.75)
    public var indicatorAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.8)

    public var hapticsEnabled = true

    public init() {}

    public static let `default` = FloatingNavStyle()
}
