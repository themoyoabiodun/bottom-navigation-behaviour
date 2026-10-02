import SwiftUI
import FloatingNavKit

enum Tab: Hashable { case home, add, stats }

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    @State private var tab: Tab = .home

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(0..<40, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(white: 0.93))
                        .frame(height: 72)
                        .overlay(Text("Row \(index + 1)"))
                }
            }
            .padding()
        }
        .floatingNavBar(
            selection: $tab,
            items: [
                .init(id: Tab.home, systemImage: "house.fill"),
                .init(id: Tab.add, systemImage: "plus.circle.fill"),
                .init(id: Tab.stats, systemImage: "chart.bar.fill")
            ]
        )
    }
}
