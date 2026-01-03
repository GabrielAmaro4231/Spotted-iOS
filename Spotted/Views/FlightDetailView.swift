import SwiftUI

struct FlightDetailView: View {
    let flight: Flight

    // MARK: - Derived values (SwiftUI-safe)

    private var city: String {
        flight.city?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var country: String {
        flight.country?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var mapTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MMM d yyyy"

        return "Aircraft \(flight.aircraftRegistration) spotted from here at \(formatter.string(from: flight.date))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                VStack(alignment: .leading, spacing: 8) {
                    Text(flight.aircraftRegistration)
                        .font(.title2)
                        .bold()

                    Text(flight.aircraftType)
                        .foregroundStyle(.secondary)

                    Divider()

                    if !city.isEmpty || !country.isEmpty {
                        Label(
                            [city, country]
                                .filter { !$0.isEmpty }
                                .joined(separator: ", "),
                            systemImage: "location.fill"
                        )
                        .font(.subheadline)
                    } else {
                        Label(
                            String(
                                format: "Lat %.5f, Lon %.5f",
                                flight.latitude,
                                flight.longitude
                            ),
                            systemImage: "location.fill"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }

                    Text(flight.date.formatted())
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Divider()

                    MiniMapView(
                        latitude: flight.latitude,
                        longitude: flight.longitude,
                        title: mapTitle
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
