import Foundation

public struct Coordinate: Codable, Equatable, Sendable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct Beach: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let name: String
    public let coordinate: Coordinate
    public let distanceKilometers: Double
    public let deliveryMinutes: Int
    public let rating: Double
    public let imageName: String

    public init(id: UUID = UUID(), name: String, coordinate: Coordinate, distanceKilometers: Double, deliveryMinutes: Int, rating: Double, imageName: String) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.distanceKilometers = distanceKilometers
        self.deliveryMinutes = deliveryMinutes
        self.rating = rating
        self.imageName = imageName
    }
}
