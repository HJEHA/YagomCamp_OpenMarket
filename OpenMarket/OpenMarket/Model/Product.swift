import Foundation

struct Product {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let images: [Any]?
    let vendors: [Any]?
    let createdAt: String
    let issuedAt: String
}
