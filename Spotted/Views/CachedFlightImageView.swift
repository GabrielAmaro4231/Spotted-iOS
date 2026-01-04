import SwiftUI

struct CachedFlightImageView: View {
    let flight: Flight

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if isLoading {
                ProgressView()
            } else {
                Color.clear
            }
        }
        .task {
            await load()
        }
    }

    private func load() async {
        guard image == nil else { return }
        isLoading = true
        image = await ImageCacheService.shared.loadImage(for: flight)
        isLoading = false
    }
}
