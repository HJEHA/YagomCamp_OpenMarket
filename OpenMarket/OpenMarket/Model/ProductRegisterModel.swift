import Foundation

struct ProductDetail: Codable {
    let name: String = "되는건가"
    let descriptions: String = "매우222"
    let price: Double = 1000
    let discountedPrice: Double?
    let currency: String = "KRW"
    let stock: Int
    let secret: String

    init(discountedPrice: Double = 0, stock: Int = 0, secret: String = "H%m27P$arJ*T*Ggt") {
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.secret = secret
    }
}
