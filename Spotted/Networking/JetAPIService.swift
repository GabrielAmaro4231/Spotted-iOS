import Foundation

struct JetAircraftInfo {
    let model: String
    let imageURL: String
}

private struct JetAPIResponse: Decodable {
    let reg: String
    let images: [JetAPIImage]

    enum CodingKeys: String, CodingKey {
        case reg = "Reg"
        case images = "Images"
    }
}

private struct JetAPIImage: Decodable {
    let image: String
    let aircraft: String
    let airline: String

    enum CodingKeys: String, CodingKey {
        case image = "Image"
        case aircraft = "Aircraft"
        case airline = "Airline"
    }
}

enum JetAPIError: Error {
    case timeout
    case invalidResponse
    case noImages
}

final class JetAPIService {

    static let shared = JetAPIService()
    private init() {}

    func fetchAircraftInfo(registration: String) async throws -> JetAircraftInfo {

        var components = URLComponents(string: "https://www.jetapi.dev/api")!
        components.queryItems = [
            .init(name: "reg", value: registration),
            .init(name: "photos", value: "1"),
            .init(name: "flights", value: "0"),
            .init(name: "only_jp", value: "true")
        ]

        let url = components.url!
        NSLog("JetAPI URL: %@", url.absoluteString)

        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw JetAPIError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(JetAPIResponse.self, from: data)

        guard let firstImage = decoded.images.first else {
            throw JetAPIError.noImages
        }

        return JetAircraftInfo(
            model: firstImage.aircraft,
            imageURL: firstImage.image
        )
    }
}
