import Foundation

struct ProductDetailToRegister: Codable {
    let name: String
    let descriptions: String
    let price: Double
    let discountedPrice: Double?
    let currency: Currency
    let stock: Int?
    var secret: String = "H%m27P$arJ*T*Ggt"
}
