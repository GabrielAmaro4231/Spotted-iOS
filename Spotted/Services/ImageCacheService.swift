import UIKit

final class ImageCacheService: ImageCacheServiceProtocol {

    private let fileManager = FileManager.default

    private var imagesDirectory: URL {

        fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AircraftImages")

    }

    func loadImage(
        imageURL: String?,
        localPath: String?,
        id: UUID
    ) async -> (UIImage?, String?) {

        if let localPath {

            let url = URL(fileURLWithPath: localPath)

            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {

                return (image, localPath)

            }

        }

        guard let imageURL,
              let url = URL(string: imageURL) else {

            return (nil, nil)

        }

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else {
                return (nil, nil)
            }

            let newPath = try saveImage(data: data, id: id)

            return (image, newPath)

        } catch {

            return (nil, nil)

        }
    }

    private func saveImage(data: Data, id: UUID) throws -> String {

        if !fileManager.fileExists(atPath: imagesDirectory.path) {

            try fileManager.createDirectory(
                at: imagesDirectory,
                withIntermediateDirectories: true
            )

        }

        let filename = "\(id.uuidString).jpg"

        let fileURL = imagesDirectory.appendingPathComponent(filename)

        try data.write(to: fileURL)

        return fileURL.path
    }
}
