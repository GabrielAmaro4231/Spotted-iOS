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

    // MARK: - Save Logic with Timeout

    private func saveFlight() async {
        isLoading = true
        errorMessage = nil

        do {
            let info = try await withThrowingTaskGroup(of: JetAPIImage.self) { group in
                group.addTask {
                    try await JetAPIService.fetchAircraftInfo(
                        registration: aircraftPrefix
                    )
                }

                group.addTask {
                    try await Task.sleep(nanoseconds: 5_000_000_000)
                    throw URLError(.timedOut)
                }

                let result = try await group.next()!
                group.cancelAll()
                return result
            }

            let newFlight = Flight(
                aircraftPrefix: aircraftPrefix,
                airport: selectedAirport,
                date: Date(),
                aircraftModel: info.Aircraft,
                airlineName: info.Airline,
                imageURL: URL(string: info.Image),
                needsRefresh: false
            )

            flights.append(newFlight)
            dismiss()

        } catch {
            errorMessage = "Aircraft data unavailable. Saved for later refresh."

            let fallbackFlight = Flight(
                aircraftPrefix: aircraftPrefix,
                airport: selectedAirport,
                date: Date(),
                aircraftModel: "Unknown aircraft",
                airlineName: "Unknown airline",
                imageURL: nil,
                needsRefresh: true
            )

            flights.append(fallbackFlight)
            dismiss()
        }

        isLoading = false
    }
}
