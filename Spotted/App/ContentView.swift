import SwiftUI
import SwiftData

struct ContentView: View {

    @Binding var isLoggedIn: Bool
    @Environment(\.modelContext) private var context

    var body: some View {

        let container = AppContainer(context: context)

        NavigationStack {

            if isLoggedIn {

                HomeView(
                    viewModel: HomeViewModel(repository: container.flightRepository),
                    container: container
                )

            } else {

                LoginView(
                    viewModel: LoginViewModel()
                ) {
                    isLoggedIn = true
                }

            }

        }
    }
}
