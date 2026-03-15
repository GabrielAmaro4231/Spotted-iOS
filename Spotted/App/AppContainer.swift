import SwiftData

final class AppContainer {

    let aircraftService: AircraftServiceProtocol
    let imageCacheService: ImageCacheServiceProtocol
    let locationService: LocationServiceProtocol
    let flightRepository: FlightRepositoryProtocol

    init(context: ModelContext) {

        aircraftService = JetAPIService()
        imageCacheService = ImageCacheService()
        locationService = LocationService()

        flightRepository = SwiftDataFlightRepository(context: context)
    }
}
