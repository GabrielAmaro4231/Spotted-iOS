import XCTest
@testable import Spotted
import CoreLocation

@MainActor
final class AddFlightViewModelTests: XCTestCase {

    var vm: AddFlightViewModel!
    var repository: MockFlightRepository!

    override func setUp() {
        super.setUp()

        repository = MockFlightRepository()

        vm = AddFlightViewModel(
            repository: repository,
            aircraftService: MockAircraftService(),
            locationService: MockLocationService()
        )
    }

    // MARK: - Normalize Tests

    func testNormalizeRemovesSpacesAndUppercases() {

        let result = vm.normalize(" pt abc ")

        XCTAssertEqual(result, "PTABC")
    }

    func testNormalizeAlreadyCorrect() {

        let result = vm.normalize("PTXYZ")

        XCTAssertEqual(result, "PTXYZ")
    }

    // MARK: - Location Test

    func testRequestLocationUpdatesLocation() {

        let expectation = expectation(description: "Location updated")

        vm.requestLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.vm.location != nil {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(vm.location)
    }

    // MARK: - Save Flight Test

    func testSaveFlightCreatesFlight() async throws {

        vm.aircraftRegistration = "PTABC"

        vm.location = CLLocation(latitude: 10, longitude: 20)

        try await vm.saveFlight()

        XCTAssertEqual(repository.savedFlights.count, 1)
    }

    // MARK: - Aircraft Service Test

    func testAircraftServiceReturnsExpectedModel() async throws {

        let service = MockAircraftService()

        let result = try await service.fetchAircraftInfo(registration: "TEST")

        XCTAssertEqual(result.model, "A320")
    }
}

// MARK: - Mock Repository

final class MockFlightRepository: FlightRepositoryProtocol {

    var savedFlights: [Flight] = []

    func save(_ flight: Flight) throws {
        savedFlights.append(flight)
    }

    func delete(_ flight: Flight) throws { }

    func saveContext() throws { }
}

// MARK: - Mock Aircraft Service

final class MockAircraftService: AircraftServiceProtocol {

    func fetchAircraftInfo(registration: String) async throws -> JetAircraftInfo {

        return JetAircraftInfo(
            model: "A320",
            imageURL: "https://test.com/image.jpg"
        )
    }
}

// MARK: - Mock Location Service

final class MockLocationService: LocationServiceProtocol {

    func requestLocation(completion: @escaping (CLLocation?) -> Void) {

        DispatchQueue.main.async {
            completion(CLLocation(latitude: 1, longitude: 1))
        }
    }
}
