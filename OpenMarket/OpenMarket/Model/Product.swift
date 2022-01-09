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
    let images: [ProductImage]?
    let vendor: Vendor?
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, vendorId, name, thumbnail, currency, price, bargainPrice, discountedPrice, stock, images, createdAt, issuedAt
        
        case vendor = "vendors"
    }
}
