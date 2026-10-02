package com.floatingnavkit

import androidx.compose.animation.core.AnimationSpec
import androidx.compose.animation.core.spring
import androidx.compose.runtime.Immutable
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Immutable
class FloatingNavBehavior(
    /** Scale applied to the nav while the content is scrolling. */
    val shrinkScale: Float = 0.8f,
    /** Milliseconds to wait after scrolling stops before the nav returns to its default size. */
    val restoreDelayMillis: Long = 800,
    /** Roughly matches the iOS spring (response 0.35, damping 0.75). */
    val animationSpec: AnimationSpec<Float> = spring(dampingRatio = 0.75f, stiffness = 320f),
    /** Space between the nav and the bottom system bar. */
    val bottomPadding: Dp = 8.dp,
)
