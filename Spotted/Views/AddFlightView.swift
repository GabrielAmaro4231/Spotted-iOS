import SwiftUI
import SwiftData

struct AddFlightView: View {
    @Environment(\.modelContext)
    private var context

    @Environment(\.dismiss)
    private var dismiss

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

            let flight = Flight(
                aircraftPrefix: aircraftPrefix,
                airportICAO: selectedAirport.icao,
                date: Date(),
                aircraftModel: info.Aircraft,
                airlineName: info.Airline,
                imageURL: URL(string: info.Image),
                needsRefresh: false
            )

            context.insert(flight)
            dismiss()

        } catch {
            let flight = Flight(
                aircraftPrefix: aircraftPrefix,
                airportICAO: selectedAirport.icao,
                date: Date(),
                aircraftModel: "Unknown aircraft",
                airlineName: "Unknown airline",
                needsRefresh: true
            )

            context.insert(flight)
            dismiss()
        }

        isLoading = false
    }
}
