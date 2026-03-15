import SwiftUI

struct AddFlightView: View {

    @ObservedObject var viewModel: AddFlightViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        Form {

            Section("Aircraft") {

                TextField(
                    "Registration",
                    text: $viewModel.aircraftRegistration
                )
                .textInputAutocapitalization(.characters)

            }

            Button("Save") {

                Task {

                    try? await viewModel.saveFlight()
                    dismiss()

                }

            }
            .disabled(viewModel.aircraftRegistration.isEmpty)

        }
        .navigationTitle("Add Aircraft")
        .onAppear {
            viewModel.requestLocation()
        }
    }
}
