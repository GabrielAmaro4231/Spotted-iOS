import SwiftUI
import SwiftData

struct FlightDetailView: View {
    let flight: Flight

    @Environment(\.modelContext)
    private var context

    @Environment(\.dismiss)
    private var dismiss

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

                if let airport = flight.airport {
                    DetailRow(title: "Airport", value: airport.name)
                    DetailRow(title: "Location", value: "\(airport.city), \(airport.country)")
                    DetailRow(title: "Codes", value: "\(airport.iata) / \(airport.icao)")
                } else {
                    DetailRow(title: "Airport", value: "Unknown airport")
                }

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
                .disabled(isRefreshing)
            }
            .padding()
        }
        .navigationTitle("Spotting")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Entry?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                context.delete(flight)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
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
    }

    private func refreshFlight() async {
        isRefreshing = true
        refreshError = nil
        rotation = 360

        do {
            let info = try await JetAPIService.fetchAircraftInfo(
                registration: flight.aircraftPrefix
            )

            flight.aircraftModel = info.Aircraft
            flight.airlineName = info.Airline
            flight.imageURL = URL(string: info.Image)
            flight.needsRefresh = false

        } catch {
            refreshError = "Request timed out. Please try again later."
        }

        isRefreshing = false
        rotation = 0
    }
}
