import Foundation

struct JetAPIResponse: Decodable {
    let Reg: String
    let Images: [JetAPIImage]
}

struct JetAPIImage: Decodable {
    let Image: String
    let Aircraft: String
    let Airline: String
}
