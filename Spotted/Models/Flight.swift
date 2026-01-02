import Foundation

struct Flight: Identifiable {
    let id = UUID()
    let aircraftPrefix: String
    let airport: Airport
    let date: Date

    let aircraftModel: String
    let airlineName: String
    let imageURL: URL?
}
