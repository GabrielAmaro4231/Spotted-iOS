import Foundation

struct Airport: Identifiable, Hashable {
    let id = UUID()
    let icao: String
    let iata: String
    let name: String
    let city: String
    let country: String
}
