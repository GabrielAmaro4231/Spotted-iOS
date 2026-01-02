import Foundation

struct Flight: Identifiable {
    let id = UUID()

    let aircraftPrefix: String
    let airport: Airport
    let date: Date

    var aircraftModel: String
    var airlineName: String
    var imageURL: URL?

    var needsRefresh: Bool
}
