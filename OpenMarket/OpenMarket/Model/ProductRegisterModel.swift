import Foundation

struct ProductDetail: Codable {
    let name: String = "킹받는다222"
    let descriptions: String = "매우222"
    let price: Double = 1000
    let discountedPrice: Double
    let currency: String = "KRW"
    let stock: Int
    let secret: String

    init(discountedPrice: Double = 0, stock: Int = 0, secret: String = "password") {
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.secret = secret
    }
}
