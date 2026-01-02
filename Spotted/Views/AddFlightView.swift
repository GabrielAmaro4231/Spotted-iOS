import SwiftUI

struct AddFlightView: View {
    @Binding var flights: [Flight]
    @Environment(\.dismiss) private var dismiss

    @State private var aircraftPrefix = ""
    @State private var selectedAirport: Airport = airports.first!

    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section(header: Text("Aircraft")) {
                TextField("Aircraft Registration", text: $aircraftPrefix)
                    .textInputAutocapitalization(.characters)
            }

            Section(header: Text("Airport")) {
                Picker("Airport", selection: $selectedAirport) {
                    ForEach(airports) { airport in
                        Text("\(airport.city) – \(airport.iata)")
                            .tag(airport)
                    }
                }
            }

            if isLoading {
                ProgressView("Fetching aircraft data…")
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("New Spotting")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        await saveFlight()
                    }
                }
                .disabled(aircraftPrefix.isEmpty || isLoading)
            }
        }
    }

    private func saveFlight() async {
        isLoading = true
        errorMessage = nil

        do {
            let info = try await JetAPIService.fetchAircraftInfo(
                registration: aircraftPrefix
            )

            let newFlight = Flight(
                aircraftPrefix: aircraftPrefix,
                airport: selectedAirport,
                date: Date(),
                aircraftModel: info.Aircraft,
                airlineName: info.Airline,
                imageURL: URL(string: info.Image)
            )

            flights.append(newFlight)
            dismiss()

        } catch {
            errorMessage = "Unable to fetch aircraft information."
        }

        isLoading = false
    }
}
