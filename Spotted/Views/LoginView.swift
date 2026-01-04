import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.secondarySystemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "airplane")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(.secondary)

                VStack(spacing: 10) {
                    Text("Spotted")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Track and remember every aircraft you see")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Button {
                    isLoggedIn = true
                } label: {
                    Text("Start Spotting")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}
