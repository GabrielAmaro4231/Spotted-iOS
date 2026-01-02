import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    @Binding var flights: [Flight]

    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

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
                DetailRow(title: "Location",
                          value: "\(flight.airport.city), \(flight.airport.country)")

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

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete Entry")
                        .frame(maxWidth: .infinity)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Spotting")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Entry?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                flights.removeAll { $0.id == flight.id }
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
