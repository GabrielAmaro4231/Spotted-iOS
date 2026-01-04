import SwiftUI
import SwiftData

struct FlightDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let flight: Flight

    @State private var isEditing = false
    @State private var editedAircraftType = ""
    @State private var editedImageURL = ""

    @State private var showDeleteConfirmation = false

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

                Text(flight.aircraftRegistration)
                    .font(.title2)
                    .bold()

                if isEditing {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("JetPhotos image URL")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("https://...", text: $editedImageURL)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                    }
                } else if !imageURL.isEmpty {
                    CachedFlightImageView(flight: flight)
                }

                Divider()

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

                if !isEditing {

                    Text(flight.date.formatted())
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Divider()

                    MiniMapView(
                        latitude: flight.latitude,
                        longitude: flight.longitude,
                        title: mapTitle
                    )

                    Label(coordinateLabel, systemImage: "location.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if isEditing {
                    Divider()

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Flight")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    toggleEdit()
                }
            }
        }
        .alert("Delete Flight?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteFlight()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .onAppear {
            editedAircraftType = aircraftType
            editedImageURL = imageURL
        }
    }

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

    private func deleteFlight() {
        context.delete(flight)
        try? context.save()
        dismiss()
    }
}
