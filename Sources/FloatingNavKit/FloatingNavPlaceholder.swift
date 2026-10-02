import SwiftUI

/// A stand-in nav with placeholder icons, used when `.floatingNav()` is called without a nav view.
/// It only exists so the scroll behavior is visible out of the box. Replace it with your own view.
public struct FloatingNavPlaceholder: View {
    private let symbols = ["house.fill", "plus.circle.fill", "chart.bar.fill", "person.fill"]
    private let slotSize: CGFloat = 44
    private let spacing: CGFloat = 33.5

    @State private var selected = 0

    public init() {}

    public var body: some View {
        ZStack(alignment: .leading) {
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: slotSize, height: slotSize)
                .offset(x: CGFloat(selected) * (slotSize + spacing))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selected)

            HStack(spacing: spacing) {
                ForEach(symbols.indices, id: \.self) { index in
                    Image(systemName: symbols[index])
                        .font(.system(size: 22))
                        .frame(width: slotSize, height: slotSize)
                        .foregroundStyle(index == selected ? Color.white : Color(white: 0.63))
                        .contentShape(Rectangle())
                        .onTapGesture { selected = index }
                }
            }
        }
        .padding(12)
        .background(Color(red: 3 / 255, green: 3 / 255, blue: 3 / 255))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.2), radius: 5.5, x: 0, y: 4)
    }
}
