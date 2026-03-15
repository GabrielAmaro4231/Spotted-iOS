import Foundation
import Combine
import CoreLocation

@MainActor
final class AddFlightViewModel: ObservableObject {

    @Published var aircraftRegistration = ""
    @Published var location: CLLocation?

    private let repository: FlightRepositoryProtocol
    private let aircraftService: AircraftServiceProtocol
    private let locationService: LocationServiceProtocol

    init(
        repository: FlightRepositoryProtocol,
        aircraftService: AircraftServiceProtocol,
        locationService: LocationServiceProtocol
    ) {

        self.repository = repository
        self.aircraftService = aircraftService
        self.locationService = locationService
    }

    func requestLocation() {

        locationService.requestLocation { location in
            self.location = location
        }
    }

    func normalize(_ registration: String) -> String {
        registration
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .uppercased()
    }

    func saveFlight() async throws {

        guard let location else { return }

        let normalized = normalize(aircraftRegistration)

        let flight = Flight(
            aircraftRegistration: normalized,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        try repository.save(flight)

        do {

            let info = try await aircraftService.fetchAircraftInfo(
                registration: normalized
            )

            flight.aircraftType = info.model
            flight.imageURL = info.imageURL

            try repository.saveContext()

        } catch {

        }
    }
}
