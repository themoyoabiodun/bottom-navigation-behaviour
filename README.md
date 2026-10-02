# FloatingNavKit

One behavior for SwiftUI, nothing else: **a bottom nav that shrinks while you scroll and returns to its default size shortly after you stop.**

It doesn't ship icons, items, selection state or styling. Bring any view you like.

| State | Nav size |
|---|---|
| Scrolling | 80% |
| Default (0.8s after scrolling stops) | 100% |

## Install

Swift Package Manager, iOS 17+:

```swift
.package(url: "https://github.com/themoyoabiodun/bottom-navigation-behaviour", from: "0.1.0")
```

## Use

Apply `floatingNav` to the `ScrollView` (or `List`) and pass your own nav view:

```swift
import FloatingNavKit

ScrollView {
    // your content
}
.floatingNav {
    MyTabBar()          // any View
}
```

## Tune the behavior

```swift
var behavior = FloatingNavBehavior()
behavior.shrinkScale = 0.8      // size while scrolling
behavior.restoreDelay = 0.8     // seconds to wait before returning to default
behavior.animation = .spring(response: 0.35, dampingFraction: 0.75)
behavior.bottomPadding = 8

ScrollView { ... }
    .floatingNav(behavior: behavior) { MyTabBar() }
```

## How it works

- iOS 18+: `onScrollPhaseChange`. Any phase other than `.idle` (dragging, momentum) counts as scrolling.
- iOS 17: falls back to touch tracking, which can't see momentum after the finger lifts, so the nav may return to default slightly early.
- The nav sits in a bottom `safeAreaInset`, scaled from its bottom edge.
- Each new scroll cancels the pending restore, so the nav never flickers between flicks.

## Example

`Example/` is a small app with a placeholder nav. Run `xcodegen generate` inside it, then open the project.
