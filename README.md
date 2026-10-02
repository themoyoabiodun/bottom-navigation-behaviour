# FloatingNavKit

Available for **SwiftUI** (root package) and **Jetpack Compose** (`android/`).

One behavior for SwiftUI, nothing else: **a bottom nav that shrinks while you scroll and returns to its default size shortly after you stop.**

It ships a placeholder icon bar so you can see the behavior immediately, but the bar is not the point. Bring any view you like.

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

Apply `floatingNav` to the `ScrollView` (or `List`). With no closure you get the placeholder icon bar (`FloatingNavPlaceholder`):

```swift
ScrollView { ... }
    .floatingNav()
```

Pass a closure to use your own nav view instead:

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

## Android (Jetpack Compose)

> The Compose version has not been compiled or run yet. It was written without an Android toolchain available, so expect to fix small build issues on first open in Android Studio.

The `android/` folder is a Gradle project with a `floatingnav` library module and a `sample` app. Open `android/` in Android Studio and let it sync.

```kotlin
FloatingNavLayout { contentPadding ->      // placeholder icon nav
    LazyColumn(contentPadding = PaddingValues(bottom = contentPadding.calculateBottomPadding())) { ... }
}

FloatingNavLayout(
    behavior = FloatingNavBehavior(shrinkScale = 0.8f, restoreDelayMillis = 800),
    nav = { MyBottomBar() },               // any composable
) { contentPadding -> ... }
```

It listens through `NestedScrollConnection`, so it works with any scrollable inside (`LazyColumn`, `verticalScroll`, ...). The nav shrinks on the first scroll delta (finger or fling) and the restore delay starts when the fling ends. `contentPadding` is the nav's height, so the last items stay clear of it.
