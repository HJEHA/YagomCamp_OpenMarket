import Foundation

struct MockProduct {
    static let json = """
                      {
                        "id": 15,
                        "vendor_id": 3,
                        "name": "pizza",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/f510cb6e689f11ecbf33d124b2c61dc4.jpg",
                        "currency": "KRW",
                        "price": 25000,
                        "bargain_price": 25000,
                        "discounted_price": 0,
                        "stock": 0,
                        "created_at": "2021-12-29 00:00:00.000",
                        "issued_at": "2021-12-29 00:00:00.000"
                      }
                      """
}
