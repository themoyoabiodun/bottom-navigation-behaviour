import SwiftUI

public extension View {
    /// Pins any view to the bottom of a scroll view as a floating nav. The nav shrinks while the
    /// scroll view is moving and returns to its default size `behavior.restoreDelay` seconds after
    /// it stops.
    ///
    /// Apply this directly to the `ScrollView` (or `List`).
    func floatingNav<Nav: View>(
        behavior: FloatingNavBehavior = .default,
        @ViewBuilder nav: () -> Nav
    ) -> some View {
        modifier(FloatingNavModifier(behavior: behavior, nav: nav()))
    }
}

struct FloatingNavModifier<Nav: View>: ViewModifier {
    let behavior: FloatingNavBehavior
    let nav: Nav

    @State private var isShrunk = false
    @State private var restoreTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .trackScrollActivity(setScrolling)
            .safeAreaInset(edge: .bottom) {
                nav
                    .scaleEffect(isShrunk ? behavior.shrinkScale : 1, anchor: .bottom)
                    .animation(behavior.animation, value: isShrunk)
                    .padding(.bottom, behavior.bottomPadding)
            }
    }

    private func setScrolling(_ scrolling: Bool) {
        restoreTask?.cancel()
        if scrolling {
            isShrunk = true
        } else {
            let delay = behavior.restoreDelay
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
