import SwiftData

final class SwiftDataFlightRepository: FlightRepositoryProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ flight: Flight) throws {
        context.insert(flight)
        try context.save()
    }

    func delete(_ flight: Flight) throws {
        context.delete(flight)
        try context.save()
    }

    func saveContext() throws {
        try context.save()
    }
}
