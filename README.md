# FloatingNavKit

A floating bottom navigation bar for SwiftUI: a sliding selection highlight, a haptic tick on
change, and a bar that shrinks while you scroll and eases back to full size once you stop.

## Install

Swift Package Manager: add this repository's URL, product `FloatingNavKit`. Requires iOS 17+.

## Use

Add one modifier to your `ScrollView` (or `List`):

```swift
import FloatingNavKit

enum Tab: Hashable { case home, add, stats }

struct Screen: View {
    @State private var tab: Tab = .home

    var body: some View {
        ScrollView { /* your content */ }
            .floatingNavBar(
                selection: $tab,
                items: [
                    .init(id: Tab.home, systemImage: "house.fill"),
                    .init(id: Tab.add, systemImage: "plus.circle.fill"),
                    .init(id: Tab.stats, assetName: "ChartIcon")
                ]
            )
    }
}
```

Items accept an SF Symbol name, an asset-catalog name, or any `Image`. Icons are tinted, so
use single-color template-friendly artwork.

## Customize

```swift
var style = FloatingNavStyle()
style.shrinkScale = 0.8       // scale while scrolling
style.restoreDelay = 0.8      // seconds after scrolling stops
style.selectedColor = .white
style.unselectedColor = .gray
style.backgroundColor = .black
style.indicatorColor = .white.opacity(0.15)
style.hapticsEnabled = true
```

Pass it with `.floatingNavBar(selection:items:style:)`. To place the bar yourself without the
scroll behavior, use `FloatingNavBar(selection:items:style:)` directly.

## Notes

- On iOS 18+ the shrink follows real scroll phases, including momentum scrolling.
- On iOS 17 it falls back to touch tracking, so the bar restores when your finger lifts rather
  than when momentum ends.
- `Example/` is a small app using the package. Generate its project with `xcodegen generate`.
