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
        .floatingNav {
            // Any view works here. FloatingNavKit only adds the scroll behavior.
            Capsule()
                .fill(Color.black)
                .frame(width: 220, height: 64)
        }
    }
}
