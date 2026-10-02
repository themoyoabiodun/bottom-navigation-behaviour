import SwiftUI

public struct FloatingNavBehavior {
    /// Scale applied to the nav while the scroll view is moving.
    public var shrinkScale: CGFloat = 0.8
    /// Seconds to wait after scrolling stops before the nav returns to its default size.
    public var restoreDelay: TimeInterval = 0.8
    public var animation: Animation = .spring(response: 0.35, dampingFraction: 0.75)
    /// Space between the nav and the bottom safe area.
    public var bottomPadding: CGFloat = 8

    public init() {}

    public static let `default` = FloatingNavBehavior()
}
