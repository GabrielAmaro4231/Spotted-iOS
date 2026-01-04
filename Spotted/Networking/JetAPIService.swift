import Foundation

struct JetAircraftInfo {
    let model: String
    let imageURL: String
}

private struct JetAPIResponse: Decodable {
    let Reg: String
    let Images: [JetAPIImage]
}

private struct JetAPIImage: Decodable {
    let Image: String
    let Aircraft: String
    let Airline: String
}

enum JetAPIError: Error {
    case timeout
    case invalidResponse
    case noImages
}

final class JetAPIService {

    static let shared = JetAPIService()
    private init() {}

    func fetchAircraftInfo(
        registration: String
    ) async throws -> JetAircraftInfo {

        guard let url = URL(
            string: "https://api.jetapi.com/aircraft/\(registration)"
        ) else {
            throw JetAPIError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoded = try JSONDecoder().decode(
            JetAPIResponse.self,
            from: data
        )

        guard let firstImage = decoded.Images.first else {
            throw JetAPIError.noImages
        }

        return JetAircraftInfo(
            model: firstImage.Aircraft,
            imageURL: firstImage.Image
        )
    }
}
