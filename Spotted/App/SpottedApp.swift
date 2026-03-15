import SwiftUI
import SwiftData

@main
struct SpottedApp: App {

    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn)
        }
        .modelContainer(for: Flight.self)
    }
}
