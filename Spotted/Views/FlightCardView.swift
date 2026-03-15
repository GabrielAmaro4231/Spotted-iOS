import SwiftUI

struct FlightCardView: View {

    let flight: Flight

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(flight.aircraftRegistration)
                .font(.subheadline)
                .fontWeight(.semibold)

            if let type = flight.aircraftType {
                Text(type)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Aircraft type unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 4)

        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2, y: 1)
    }
}
