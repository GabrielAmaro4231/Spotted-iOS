import Foundation
import SwiftData

@Model
class Flight {
    var aircraftPrefix: String
    var airportICAO: String
    var date: Date

    var aircraftModel: String
    var airlineName: String
    var imageURL: URL?

    var needsRefresh: Bool

    init(
        aircraftPrefix: String,
        airportICAO: String,
        date: Date,
        aircraftModel: String,
        airlineName: String,
        imageURL: URL? = nil,
        needsRefresh: Bool = false
    ) {
        self.aircraftPrefix = aircraftPrefix
        self.airportICAO = airportICAO
        self.date = date
        self.aircraftModel = aircraftModel
        self.airlineName = airlineName
        self.imageURL = imageURL
        self.needsRefresh = needsRefresh
    }
}

extension Flight {
    @Transient
    var airport: Airport? {
        airports.first { $0.icao == airportICAO }
    }
}
