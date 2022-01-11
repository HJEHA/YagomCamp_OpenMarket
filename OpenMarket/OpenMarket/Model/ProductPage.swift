import Foundation

struct ProductPage: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let products: [Product]
    let lastPage: Int
    let hasNextPage: Bool
    let hasPrevPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case itemsPerPage, totalCount, offset, limit, lastPage

        case products = "pages"
        case pageNumber = "pageNo"
        case hasNextPage = "hasNext"
        case hasPrevPage = "hasPrev"
    }
}
