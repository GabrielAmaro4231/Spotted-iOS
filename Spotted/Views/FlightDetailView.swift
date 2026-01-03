import SwiftUI
import SwiftData

struct FlightDetailView: View {
    @Environment(\.modelContext) private var context

    let flight: Flight

    // MARK: - Edit state

    @State private var isEditing = false
    @State private var editedAircraftType = ""
    @State private var editedImageURL = ""

    // MARK: - Derived values

    private var aircraftType: String {
        flight.aircraftType?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var imageURL: String {
        flight.imageURL?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var mapTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MMM d yyyy"

        return "Aircraft \(flight.aircraftRegistration) spotted here at \(formatter.string(from: flight.date))"
    }

    private var coordinateLabel: String {
        String(
            format: "Lat %.5f, Lon %.5f",
            flight.latitude,
            flight.longitude
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if isEditing {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("JetPhotos image URL")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField(
                            "https://...",
                            text: $editedImageURL
                        )
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                    }
                } else if let url = URL(string: imageURL), !imageURL.isEmpty {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }
                }

                Divider()

                Text(flight.aircraftRegistration)
                    .font(.title2)
                    .bold()

                if isEditing {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Aircraft type")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField(
                            "e.g. Airbus A320",
                            text: $editedAircraftType
                        )
                        .textFieldStyle(.roundedBorder)
                    }
                } else if !aircraftType.isEmpty {
                    Text(aircraftType)
                        .foregroundStyle(.secondary)
                }

                Divider()

                Label(
                    coordinateLabel,
                    systemImage: "location.fill"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)

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
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isEditing)   // ✅ THIS IS THE KEY LINE
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    toggleEdit()
                }
            }
        }
        .onAppear {
            editedAircraftType = aircraftType
            editedImageURL = imageURL
        }
    }

    // MARK: - Actions

    private func toggleEdit() {
        if isEditing {
            saveChanges()
        }
        isEditing.toggle()
    }

    private func saveChanges() {
        let type = editedAircraftType
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let image = editedImageURL
            .trimmingCharacters(in: .whitespacesAndNewlines)

        flight.aircraftType = type.isEmpty ? nil : type
        flight.imageURL = image.isEmpty ? nil : image

        try? context.save()
    }
}
