import UIKit

protocol ImageCacheServiceProtocol {

    func loadImage(
        imageURL: String?,
        localPath: String?,
        id: UUID
    ) async -> (UIImage?, String?)

}
