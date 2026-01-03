import SwiftUI
import SwiftData
import CoreLocation

struct AddFlightView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = LocationManager()

    @State private var aircraftRegistration = ""
    @State private var aircraftType = ""

    var body: some View {
        Form {
            Section("Aircraft") {
                TextField("Registration", text: $aircraftRegistration)
                TextField("Type", text: $aircraftType)
            }

            Section("Location") {
                if locationManager.isLoading {
                    ProgressView("Getting location…")
                } else if let error = locationManager.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                } else if let location = locationManager.location {
                    Text(
                        String(
                            format: "Lat %.4f, Lon %.4f",
                            location.coordinate.latitude,
                            location.coordinate.longitude
                        )
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                } else {
                    Text("Location not available")
                        .foregroundStyle(.secondary)
                }
            }

            Button("Save") {
                saveFlight()
            }
            .disabled(!canSave)
        }
        .navigationTitle("Add Aircraft")
        .onAppear {
            locationManager.requestLocation()
        }
    }

    private var canSave: Bool {
        !aircraftRegistration.isEmpty &&
        !aircraftType.isEmpty &&
        locationManager.location != nil
    }

    private func saveFlight() {
        guard let location = locationManager.location else { return }

        let flight = Flight(
            aircraftRegistration: aircraftRegistration,
            aircraftType: aircraftType,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        context.insert(flight)
        dismiss()
    }
}
