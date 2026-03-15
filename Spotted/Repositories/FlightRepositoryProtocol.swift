protocol FlightRepositoryProtocol {

    func save(_ flight: Flight) throws
    func delete(_ flight: Flight) throws
    func saveContext() throws

}
