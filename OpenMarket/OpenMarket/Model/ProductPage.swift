import Foundation

struct ProductPage: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNextPage: Bool
    let hasPrevpage: Bool
    
    enum CodingKeys: String, CodingKey {
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case pages
        case lastPage
        
        case pageNumber = "page_no"
        case hasNextPage = "has_next"
        case hasPrevpage = "has_prev"
    }
}
