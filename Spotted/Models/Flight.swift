import Foundation
import SwiftData

@Model
final class Flight {
    var id: UUID
    var aircraftRegistration: String
    var aircraftType: String?          // ← now optional
    var imageURL: String?              // ← JetPhotos
    var localImagePath: String?
    var latitude: Double
    var longitude: Double
    var city: String?
    var country: String?
    var date: Date

    init(
        aircraftRegistration: String,
        aircraftType: String? = nil,
        imageURL: String? = nil,
        localImagePath: String? = nil,
        latitude: Double,
        longitude: Double,
        city: String? = nil,
        country: String? = nil,
        date: Date = .now
    ) {
        self.id = UUID()
        self.aircraftRegistration = aircraftRegistration
        self.aircraftType = aircraftType
        self.imageURL = imageURL
        self.localImagePath = localImagePath
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.country = country
        self.date = date
    }
}
