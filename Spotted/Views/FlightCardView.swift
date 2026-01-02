import SwiftUI

struct FlightCardView: View {
    let flight: Flight

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(flight.aircraftPrefix)
                .font(.headline)

            Text(flight.aircraftModel)
                .foregroundColor(.secondary)

            Text(flight.airlineName)

            Text("\(flight.airport.iata) / \(flight.airport.icao)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(flight.date, style: .date)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}
