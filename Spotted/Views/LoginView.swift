import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Spotted")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button {
                isLoggedIn = true
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}
