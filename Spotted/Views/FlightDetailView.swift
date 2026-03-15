import SwiftUI

struct FlightDetailView: View {

    let flight: Flight

    @ObservedObject var viewModel: FlightDetailViewModel
    let imageService: ImageCacheServiceProtocol

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 16) {

                Text(flight.aircraftRegistration)
                    .font(.title2)
                    .bold()

                if flight.imageURL != nil {

                    CachedFlightImageView(
                        flight: flight,
                        imageService: imageService
                    )

                }

                if let type = flight.aircraftType {

                    Text(type)
                        .foregroundStyle(.secondary)

                }

                Text(flight.date.formatted())
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                MiniMapView(
                    latitude: flight.latitude,
                    longitude: flight.longitude,
                    title: "Aircraft spotted here"
                )

                Button(role: .destructive) {

                    try? viewModel.deleteFlight(flight)
                    dismiss()

                } label: {

                    Text("Delete Flight")

                }

            }
            .padding()

        }
        .navigationTitle("Details")
    }
}
