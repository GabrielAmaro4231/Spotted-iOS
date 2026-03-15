import SwiftUI

struct CachedFlightImageView: View {

    let flight: Flight
    let imageService: ImageCacheServiceProtocol

    @State private var image: UIImage?
    @State private var loading = false

    var body: some View {

        Group {

            if let image {

                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()

            } else if loading {

                ProgressView()

            } else {

                Color.clear

            }

        }
        .task {

            loading = true

            let result = await imageService.loadImage(
                imageURL: flight.imageURL,
                localPath: flight.localImagePath,
                id: flight.id
            )

            image = result.0

            if let newPath = result.1 {
                flight.localImagePath = newPath
            }

            loading = false

        }
    }
}
