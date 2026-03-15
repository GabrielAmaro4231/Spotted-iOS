import Foundation

protocol AircraftServiceProtocol {

    func fetchAircraftInfo(registration: String) async throws -> JetAircraftInfo

}
