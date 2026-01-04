import SwiftUI
import SwiftData
import CoreLocation

struct AddFlightView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = LocationManager()

    @State private var aircraftRegistration = ""

    var body: some View {
        Form {
            Section("Aircraft") {
                TextField("Registration", text: $aircraftRegistration)
                    .textInputAutocapitalization(.characters)
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

    // MARK: - Validation

    private var canSave: Bool {
        !aircraftRegistration.isEmpty &&
        locationManager.location != nil
    }

    // MARK: - Save & background enrichment

    private func saveFlight() {
        guard let location = locationManager.location else { return }

        let flight = Flight(
            aircraftRegistration: aircraftRegistration,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        context.insert(flight)
        dismiss()

        Task.detached(priority: .background) {
            await enrichFlightIfPossible(flight)
        }
    }

    @MainActor
    private func enrichFlightIfPossible(_ flight: Flight) async {
        do {
            let info = try await JetAPIService.shared.fetchAircraftInfo(
                registration: flight.aircraftRegistration
            )

            flight.aircraftType = info.model
            flight.imageURL = info.imageURL

        } catch {
            // API offline / timeout → silently ignore
            // User can edit manually later
        }
    }
}
