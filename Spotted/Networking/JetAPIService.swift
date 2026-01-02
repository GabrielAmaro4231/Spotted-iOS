import Foundation

final class JetAPIService {

    static func fetchAircraftInfo(
        registration: String
    ) async throws -> JetAPIImage {

        let urlString =
        "https://www.jetapi.dev/api?reg=\(registration)&photos=1&flights=0&only_jp=true"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(JetAPIResponse.self, from: data)

        guard let image = decoded.Images.first else {
            throw URLError(.cannotParseResponse)
        }

        return image
    }
}
