import SwiftUI

public struct FloatingNavItem<ID: Hashable>: Identifiable {
    public let id: ID
    let image: Image

    public init(id: ID, image: Image) {
        self.id = id
        self.image = image
    }

    public init(id: ID, systemImage: String) {
        self.init(id: id, image: Image(systemName: systemImage))
    }

    public init(id: ID, assetName: String, bundle: Bundle? = nil) {
        self.init(id: id, image: Image(assetName, bundle: bundle))
    }
}
