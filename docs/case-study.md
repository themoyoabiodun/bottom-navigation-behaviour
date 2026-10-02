# The nav bar that gets out of the way: turning one tiny interaction into a reusable package

*A design engineer's case study*

## The problem I kept noticing

Bottom navigation has a quiet tension. It has to be there, always reachable. But the moment you start scrolling, it's a slab of UI sitting on top of the thing you actually came to see.

Most apps pick a side. Either the bar stays fixed and eats screen space, or it hides completely and you have to scroll up to get it back. Both work. Neither feels alive.

Then I paid attention to how Instagram handles it. I don't know how their team built it, and I'm not going to pretend I do. This is a reading from the outside, as a user. What I noticed is that the bar doesn't disappear and doesn't just sit there. It *reacts*. You scroll, it recedes. You stop, it settles back. It never leaves, it just gets out of your way, and the whole screen feels like it's responding to your thumb.

That's a design decision hiding inside a motion. I wanted to build it properly, and then I wanted to make it something other people could drop into their own apps.

## The brief I gave myself

I was building a SwiftUI budgeting app from a Figma design. The brief for the nav was two sentences:

- While the user scrolls, the nav shrinks from 100% to 80%.
- When they stop, it returns to 100%.

Simple to say. The details took longer, and that's where the craft was.

## Where "simple" got complicated

**1. "When they stop" is not when the finger lifts.**

My first version used a drag gesture on the scroll view: finger down, shrink; finger up, grow. It looked fine in a quick test and felt wrong in use. A flick keeps the content moving long after the finger leaves. The nav would pop back to full size while the list was still flying underneath it.

The right signal is the scroll view's own state, including momentum. On iOS 18 and later, SwiftUI exposes this through scroll phases, and anything other than idle counts as scrolling. On iOS 17 I fall back to touch tracking, which can't see momentum. I documented that limit rather than hiding it.

**2. The comeback needs a pause.**

If the nav grows the instant scrolling stops, it flickers between flicks. You flick, it grows, you flick again, it shrinks. It reads as jitter.

So I added a 0.8-second delay before the nav returns to default. Every new scroll cancels the pending return. The nav only settles once you've really stopped. That small debounce took the behavior from "reactive" to "composed".

**3. The animation bug that wasn't visible.**

At one point the shrink-and-regrow simply stopped working, with no error. The cause was mixing animated and unanimated state changes in the same block, plus nested delayed callbacks. The fix was boring and reliable: plain state mutations, one implicit animation tied to the state value, and a single flat delayed task.

I also learned not to trust my own testing here. Tapping and swiping in a simulator can make animations look instant. To verify, I slowed the restore delay way down and measured the pill's actual pixel width: 80% while scrolling, back to full size after the delay.

## The second design decision: what's the product?

Once it worked in the app, I extracted it into a Swift package. My first draft bundled everything: the icon bar, the sliding highlight, selection state, haptics.

Then I stepped back and asked what I was really offering. It wasn't the icons. Every app has its own. The reusable thing was the behavior.

So I cut the package down to one idea. You hand it any view, and it handles how that view responds to scrolling:

```swift
ScrollView {
    // your content
}
.floatingNav {
    MyTabBar()   // any view
}
```

Four knobs, nothing else: shrink scale, restore delay, animation, bottom padding.

I did bring a placeholder icon bar back, because a behavior package you can't see working is hard to evaluate. Call `.floatingNav()` with no closure and you get a stand-in bar. It's clearly labeled as a placeholder, and it's one line to replace.

That's the part I'd flag for other design engineers: **the instinct is to ship the component. Often the thing worth shipping is the behavior.** A component has opinions about visuals. A behavior travels.

## Taking it to Android

The same interaction maps cleanly onto Jetpack Compose. Instead of scroll phases, it listens through a nested scroll connection. The nav shrinks on the first scroll delta, whether finger or fling, and the restore timer starts when the fling ends. Because it hooks in at that level, it works with any scrollable inside: lazy lists, plain scroll containers, and so on.

An honest note: I wrote the Compose version without an Android toolchain on my machine. It hasn't been compiled or run yet, and the repo says so. I'd rather ship it labeled than hold it back or oversell it.

## What I took away

- **Motion is a decision, not a decoration.** "Shrink to 80%" is a statement about hierarchy: content first, chrome second, but chrome always present.
- **Time is a design material.** The 0.8-second pause did more for the feel than any spring tuning.
- **Verify motion with numbers.** If you can measure it, measure it. Your eyes will forgive things your users won't.
- **Extract the behavior, not the component.** What people can reuse is the part that doesn't carry your visual identity.
- **Say what you haven't tested.** It builds trust.

## Try it

The package is open source, with a tagged release (v0.1.0):

https://github.com/themoyoabiodun/bottom-navigation-behaviour

Swift Package Manager, iOS 17+:

```swift
.package(url: "https://github.com/themoyoabiodun/bottom-navigation-behaviour", from: "0.1.0")
```

If you use it, or if the iOS 17 fallback or the Compose version breaks for you, I'd like to hear about it.

---

## Short version for LinkedIn

I kept noticing something about Instagram's bottom nav. It doesn't hide when you scroll and it doesn't sit there like a slab. It recedes while you scroll and settles back when you stop. I don't know how they built it, but as a user it makes the whole screen feel responsive.

So I rebuilt that interaction in SwiftUI. The rule is simple: the nav shrinks to 80% while you scroll and returns to 100% shortly after you stop.

What made it hard:
• "Stop" isn't when your finger lifts. A flick keeps scrolling, so I track real scroll state, momentum included.
• Growing back instantly caused flicker between flicks. A 0.8s delay, cancelled by any new scroll, fixed it.
• I checked the animation by measuring the pill's pixel width instead of trusting my eyes.

Then I made a call I'd recommend to other design engineers. My first package bundled the icons, selection state and haptics. I cut all of it. The thing worth sharing was the behavior, not the component. Now you pass in any nav view and it handles the scroll response.

It's open source, with a Swift package and a Jetpack Compose version. The Compose version is untested, and the repo says so.

https://github.com/themoyoabiodun/bottom-navigation-behaviour

#SwiftUI #iOSDevelopment #DesignEngineering #UX #OpenSource
