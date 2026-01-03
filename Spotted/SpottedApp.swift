import SwiftUI
import SwiftData

@main
struct SpottedApp: App {
    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    HomeView(isLoggedIn: $isLoggedIn)
                } else {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
            }
        }
        .modelContainer(for: Flight.self)
    }
}
