package com.floatingnavkit

import androidx.compose.animation.core.spring
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Add
import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.unit.dp

/**
 * A stand-in nav with placeholder icons, used when [FloatingNavLayout] gets no `nav`.
 * It only exists so the scroll behavior is visible out of the box. Replace it with your own view.
 */
@Composable
fun FloatingNavPlaceholder(modifier: Modifier = Modifier) {
    val icons = listOf(Icons.Filled.Home, Icons.Filled.Add, Icons.Filled.Search, Icons.Filled.Person)
    val slot = 44.dp
    val spacing = 33.5.dp
    var selected by remember { mutableIntStateOf(0) }
    val indicatorX by animateDpAsState(
        targetValue = (slot + spacing) * selected,
        animationSpec = spring(dampingRatio = 0.8f, stiffness = 250f),
        label = "indicator",
    )

    Box(
        modifier
            .shadow(6.dp, CircleShape)
            .clip(CircleShape)
            .background(Color(0xFF030303))
            .padding(12.dp),
    ) {
        Box(
            Modifier
                .offset(x = indicatorX)
                .size(slot)
                .clip(CircleShape)
                .background(Color.White.copy(alpha = 0.15f)),
        )
        Row(horizontalArrangement = Arrangement.spacedBy(spacing)) {
            icons.forEachIndexed { index, icon ->
                Box(
                    Modifier
                        .size(slot)
                        .clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null,
                        ) { selected = index },
                    contentAlignment = Alignment.Center,
                ) {
                    Image(
                        imageVector = icon,
                        contentDescription = null,
                        modifier = Modifier.size(24.dp),
                        colorFilter = ColorFilter.tint(
                            if (index == selected) Color.White else Color(0xFFA1A1A1),
                        ),
                    )
                }
            }
        }
    }
}
