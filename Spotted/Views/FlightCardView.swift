import SwiftUI

struct FlightCardView: View {
    let flight: Flight

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(flight.aircraftRegistration)
                .font(.headline)

            Text(flight.aircraftType)
                .foregroundStyle(.secondary)

            Text(
                String(
                    format: "Lat %.4f, Lon %.4f",
                    flight.latitude,
                    flight.longitude
                )
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Text(flight.date, style: .date)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}
