import Foundation
import SwiftData

@Model
final class Flight {
    var id: UUID
    var aircraftRegistration: String
    var aircraftType: String
    var date: Date

    // Location (core)
    var latitude: Double
    var longitude: Double

    // Location (optional metadata, future use)
    var city: String?
    var country: String?

    init(
        aircraftRegistration: String,
        aircraftType: String,
        date: Date = .now,
        latitude: Double,
        longitude: Double,
        city: String? = nil,
        country: String? = nil
    ) {
        self.id = UUID()
        self.aircraftRegistration = aircraftRegistration
        self.aircraftType = aircraftType
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.country = country
    }
}
