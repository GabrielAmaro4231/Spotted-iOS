import SwiftUI

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @State private var flights: [Flight] = sampleFlights
    @State private var showAddFlight = false

    var body: some View {
        List {
            ForEach(flights) { flight in
                NavigationLink {
                    FlightDetailView(
                        flight: flight,
                        flights: $flights
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(flight.aircraftPrefix)
                            .font(.headline)

                        Text("\(flight.airport.iata) / \(flight.airport.icao)")
                            .foregroundColor(.secondary)

                        Text(flight.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowInsets(.init())
            }
        }
        .listStyle(.plain)
        .toolbar {

            // Quit — left
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Quit") {
                    isLoggedIn = false
                }
            }

            // Add — right
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddFlight = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(isPresented: $showAddFlight) {
            AddFlightView(flights: $flights)
        }
    }
}
