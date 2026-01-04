import UIKit

final class ImageCacheService {

    static let shared = ImageCacheService()
    private init() {}

    private let fileManager = FileManager.default

    private var imagesDirectory: URL {
        fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AircraftImages")
    }

    func loadImage(for flight: Flight) async -> UIImage? {
        // 1️⃣ Load from disk if exists
        if let path = flight.localImagePath {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                return image
            }
        }

        // 2️⃣ Download if missing
        guard let urlString = flight.imageURL,
              let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }

            try saveImage(data: data, for: flight)
            return image
        } catch {
            return nil
        }
    }

    private func saveImage(data: Data, for flight: Flight) throws {
        if !fileManager.fileExists(atPath: imagesDirectory.path) {
            try fileManager.createDirectory(
                at: imagesDirectory,
                withIntermediateDirectories: true
            )
        }

        let filename = "\(flight.id.uuidString).jpg"
        let fileURL = imagesDirectory.appendingPathComponent(filename)

        try data.write(to: fileURL)

        flight.localImagePath = fileURL.path
    }
}
