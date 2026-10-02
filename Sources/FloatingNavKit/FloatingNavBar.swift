import SwiftUI
import UIKit

/// The bar itself: a capsule of icons with a highlight that slides to the selected item.
/// Use `.floatingNavBar(...)` on a ScrollView if you also want the shrink-on-scroll behavior.
public struct FloatingNavBar<ID: Hashable>: View {
    @Binding private var selection: ID
    private let items: [FloatingNavItem<ID>]
    private let style: FloatingNavStyle

    public init(selection: Binding<ID>, items: [FloatingNavItem<ID>], style: FloatingNavStyle = .default) {
        _selection = selection
        self.items = items
        self.style = style
    }

    private var selectedIndex: Int {
        items.firstIndex { $0.id == selection } ?? 0
    }

    private var indicatorOffset: CGFloat {
        CGFloat(selectedIndex) * (style.slotSize + style.itemSpacing)
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            Circle()
                .fill(style.indicatorColor)
                .frame(width: style.slotSize, height: style.slotSize)
                .offset(x: indicatorOffset)
                .animation(style.indicatorAnimation, value: selection)

            HStack(spacing: style.itemSpacing) {
                ForEach(items) { item in
                    item.image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: style.iconSize, height: style.iconSize)
                        .frame(width: style.slotSize, height: style.slotSize)
                        .foregroundStyle(item.id == selection ? style.selectedColor : style.unselectedColor)
                        .contentShape(Rectangle())
                        .onTapGesture { select(item.id) }
                }
            }
        }
        .padding(style.contentPadding)
        .background(style.backgroundColor)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.2), radius: 5.5, x: 0, y: 4)
    }

    private func select(_ id: ID) {
        guard id != selection else { return }
        if style.hapticsEnabled {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        selection = id
    }
}
