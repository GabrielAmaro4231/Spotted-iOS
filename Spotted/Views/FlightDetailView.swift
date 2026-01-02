import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    @Binding var flights: [Flight]

    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteConfirmation = false
    @State private var isRefreshing = false
    @State private var refreshError: String?
    @State private var rotation: Double = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let imageURL = flight.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(flight.aircraftPrefix)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                DetailRow(title: "Aircraft", value: flight.aircraftModel)
                DetailRow(title: "Airline", value: flight.airlineName)

                DetailRow(title: "Airport", value: flight.airport.name)
                DetailRow(
                    title: "Location",
                    value: "\(flight.airport.city), \(flight.airport.country)"
                )

                DetailRow(
                    title: "Codes",
                    value: "\(flight.airport.iata) / \(flight.airport.icao)"
                )

                DetailRow(
                    title: "Date",
                    value: flight.date.formatted(
                        date: .long,
                        time: .shortened
                    )
                )

                if let refreshError {
                    Text(refreshError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete Entry")
                        .frame(maxWidth: .infinity)
                }
                .padding(.top)
                .disabled(isRefreshing) // 🚫 Disabled during refresh
            }
            .padding()
        }
        .navigationTitle("Spotting")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isRefreshing) // 🚫 Disable back button
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if flight.needsRefresh {
                    Button {
                        Task {
                            await refreshFlight()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(rotation))
                            .animation(
                                isRefreshing
                                ? .linear(duration: 1).repeatForever(autoreverses: false)
                                : .default,
                                value: rotation
                            )
                    }
                    .disabled(isRefreshing)
                }
            }
        }
        .alert("Delete Entry?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                flights.removeAll { $0.id == flight.id }
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    // MARK: - Refresh Logic with Timeout

    private func refreshFlight() async {
        guard let index = flights.firstIndex(where: { $0.id == flight.id }) else {
            return
        }

        isRefreshing = true
        refreshError = nil
        rotation = 0
        rotation = 360 // 🔄 start spinning

        do {
            let info = try await withThrowingTaskGroup(of: JetAPIImage.self) { group in
                group.addTask {
                    try await JetAPIService.fetchAircraftInfo(
                        registration: flight.aircraftPrefix
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

            flights[index].aircraftModel = info.Aircraft
            flights[index].airlineName = info.Airline
            flights[index].imageURL = URL(string: info.Image)
            flights[index].needsRefresh = false

        } catch {
            refreshError = "Request timed out. Please try again later."
        }

        // ✅ STOP animation cleanly
        isRefreshing = false
        rotation = 0
    }
}
