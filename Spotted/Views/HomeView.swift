import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var isLoggedIn: Bool

    @Query(sort: \Flight.date, order: .reverse)
    private var flights: [Flight]

    @Environment(\.modelContext)
    private var context

    @State private var showAddFlight = false

    var body: some View {
        List {
            ForEach(flights) { flight in
                NavigationLink {
                    FlightDetailView(flight: flight)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {

                        Text(flight.aircraftRegistration)
                            .font(.headline)

                        Text(flight.aircraftType)
                            .foregroundColor(.secondary)

                        Text(
                            String(
                                format: "Lat %.4f, Lon %.4f",
                                flight.latitude,
                                flight.longitude
                            )
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)

                        Text(flight.date, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowInsets(.init())
            }
            .onDelete(perform: deleteFlights)
        }
        .listStyle(.plain)
        .navigationTitle("Spotting")
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {
                Button("Quit") {
                    isLoggedIn = false
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddFlight = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddFlight) {
            NavigationStack {
                AddFlightView()
            }
        }
    }

    private func deleteFlights(at offsets: IndexSet) {
        for index in offsets {
            context.delete(flights[index])
        }
    }
}
