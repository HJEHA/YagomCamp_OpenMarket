import Foundation

struct Product: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let images: [Image]?
    let vendors: Vendor?
    let createdAt: String
    let issuedAt: String
}
