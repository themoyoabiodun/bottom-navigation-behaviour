package com.floatingnavkit

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.nestedscroll.NestedScrollConnection
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Velocity
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * Pins [nav] to the bottom of [content]. The nav shrinks while anything inside [content] scrolls
 * (LazyColumn, verticalScroll, ...) and returns to its default size
 * [FloatingNavBehavior.restoreDelayMillis] after scrolling stops.
 *
 * [content] receives padding that keeps its last items clear of the nav.
 * With no [nav] you get [FloatingNavPlaceholder].
 */
@Composable
fun FloatingNavLayout(
    modifier: Modifier = Modifier,
    behavior: FloatingNavBehavior = FloatingNavBehavior(),
    nav: @Composable () -> Unit = { FloatingNavPlaceholder() },
    content: @Composable (contentPadding: PaddingValues) -> Unit,
) {
    val currentBehavior by rememberUpdatedState(behavior)
    val isShrunk = remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()
    val restoreJob = remember { arrayOfNulls<Job>(1) }

    val connection = remember {
        fun setScrolling(scrolling: Boolean) {
            restoreJob[0]?.cancel()
            if (scrolling) {
                isShrunk.value = true
            } else {
                restoreJob[0] = scope.launch {
                    delay(currentBehavior.restoreDelayMillis)
                    isShrunk.value = false
                }
            }
        }

        object : NestedScrollConnection {
            // Fires for finger drags and for the fling that follows.
            override fun onPreScroll(available: Offset, source: NestedScrollSource): Offset {
                if (available != Offset.Zero) setScrolling(true)
                return Offset.Zero
            }

            // Fires once the drag has ended and any momentum has finished.
            override suspend fun onPostFling(consumed: Velocity, available: Velocity): Velocity {
                setScrolling(false)
                return Velocity.Zero
            }
        }
    }

    val scale by animateFloatAsState(
        targetValue = if (isShrunk.value) behavior.shrinkScale else 1f,
        animationSpec = behavior.animationSpec,
        label = "floatingNavScale",
    )

    var navHeightPx by remember { mutableStateOf(0) }
    val navHeight = with(LocalDensity.current) { navHeightPx.toDp() }

    Box(modifier.nestedScroll(connection)) {
        content(PaddingValues(bottom = navHeight))

        Box(
            Modifier
                .align(Alignment.BottomCenter)
                .onSizeChanged { navHeightPx = it.height }
                .navigationBarsPadding()
                .padding(bottom = behavior.bottomPadding),
        ) {
            Box(
                Modifier.graphicsLayer {
                    scaleX = scale
                    scaleY = scale
                    transformOrigin = TransformOrigin(0.5f, 1f)
                },
            ) {
                nav()
            }
        }
    }
}
