import SwiftUI
import FloatingNavKit

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
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
        .floatingNav() // placeholder icons; pass a closure to use your own nav
    }
}
