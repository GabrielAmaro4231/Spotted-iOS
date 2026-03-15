import SwiftUI
import MapKit

struct MiniMapView: View {

    let latitude: Double
    let longitude: Double
    let title: String

    private var coordinate: CLLocationCoordinate2D {

        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

    }

    @State private var position: MapCameraPosition

    init(latitude: Double, longitude: Double, title: String) {

        self.latitude = latitude
        self.longitude = longitude
        self.title = title

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.02,
                longitudeDelta: 0.02
            )
        )

        _position = State(initialValue: .region(region))
    }

    var body: some View {

        Map(position: $position) {

            Marker(title, coordinate: coordinate)

        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
