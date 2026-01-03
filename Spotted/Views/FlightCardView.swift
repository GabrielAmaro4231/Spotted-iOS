import SwiftUI

struct FlightCardView: View {
    let flight: Flight

    private var aircraftType: String {
        flight.aircraftType?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(flight.aircraftRegistration)
                .font(.headline)

            if !aircraftType.isEmpty {
                Text(aircraftType)
                    .foregroundStyle(.secondary)
            } else {
                Text("Aircraft type unknown")
                    .foregroundStyle(.tertiary)
            }

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
