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

    private var canSave: Bool {
        !aircraftRegistration.isEmpty &&
        locationManager.location != nil
    }

    private func saveFlight() {

        guard let location = locationManager.location else {
            return
        }

        let normalizedReg = aircraftRegistration
            .uppercased()
            .replacingOccurrences(of: " ", with: "")

        let flight = Flight(
            aircraftRegistration: normalizedReg,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        context.insert(flight)
        try? context.save()

        Task {
            await enrichFlightIfPossible(flight)
        }

        dismiss()
    }

    @MainActor
    private func enrichFlightIfPossible(_ flight: Flight) async {
        do {

            let info = try await JetAPIService.shared.fetchAircraftInfo(
                registration: flight.aircraftRegistration
            )

            flight.aircraftType = info.model
            flight.imageURL = info.imageURL

            try context.save()

        } catch {
        }
    }
}
