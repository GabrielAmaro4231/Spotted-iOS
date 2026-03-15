import Combine
import Foundation

final class HomeViewModel: ObservableObject {

    private let repository: FlightRepositoryProtocol

    init(repository: FlightRepositoryProtocol) {
        self.repository = repository
    }

    func deleteFlight(_ flight: Flight) throws {
        try repository.delete(flight)
    }
}
