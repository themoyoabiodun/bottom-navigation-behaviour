import SwiftUI

public extension View {
    /// Pins a floating nav bar to the bottom of a ScrollView. The bar shrinks while the
    /// scroll view is moving and returns to full size `style.restoreDelay` seconds after it stops.
    ///
    /// Apply this directly to the `ScrollView` (or `List`).
    func floatingNavBar<ID: Hashable>(
        selection: Binding<ID>,
        items: [FloatingNavItem<ID>],
        style: FloatingNavStyle = .default
    ) -> some View {
        modifier(FloatingNavModifier(selection: selection, items: items, style: style))
    }
}

struct FloatingNavModifier<ID: Hashable>: ViewModifier {
    @Binding var selection: ID
    let items: [FloatingNavItem<ID>]
    let style: FloatingNavStyle

    @State private var isShrunk = false
    @State private var restoreTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .trackScrollActivity(setScrolling)
            .safeAreaInset(edge: .bottom) {
                FloatingNavBar(selection: $selection, items: items, style: style)
                    .scaleEffect(isShrunk ? style.shrinkScale : 1, anchor: .bottom)
                    .animation(style.scaleAnimation, value: isShrunk)
                    .padding(.bottom, style.bottomPadding)
            }
    }

    private func setScrolling(_ scrolling: Bool) {
        restoreTask?.cancel()
        if scrolling {
            isShrunk = true
        } else {
            let delay = style.restoreDelay
            restoreTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(delay))
                guard !Task.isCancelled else { return }
                isShrunk = false
            }
        }
    }
}

private extension View {
    /// iOS 18+ reports real scroll phases (including momentum). iOS 17 falls back to touch tracking,
    /// which can't see momentum scrolling after the finger lifts.
    @ViewBuilder
    func trackScrollActivity(_ onChange: @escaping (Bool) -> Void) -> some View {
        if #available(iOS 18.0, *) {
            onScrollPhaseChange { _, newPhase in
                onChange(newPhase != .idle)
            }
        } else {
            simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onChange(true) }
                    .onEnded { _ in onChange(false) }
            )
        }
    }
}
