import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        TabView {
            HomeView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
        }
    }
}
