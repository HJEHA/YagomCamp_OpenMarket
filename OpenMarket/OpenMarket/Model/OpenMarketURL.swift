import Foundation

protocol URLProtocol {
    var url: URL? { get }
}

enum OpenMarketURL: URLProtocol {
    private static let apiHost = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case productDetail(id: Int)
    case productPage(_ pageNumber: Int, _ itemsPerPage: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: "\(OpenMarketURL.apiHost)healthChecker")
        case .productDetail(let id):
            return URL(string: "\(OpenMarketURL.apiHost)api/products/\(id)")
        case .productPage(let pageNumber, let itemsPerPage):
            var urlComponents = URLComponents(string: "\(OpenMarketURL.apiHost)api/products?")
            let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
            let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            urlComponents?.queryItems?.append(pageNumberQuery)
            urlComponents?.queryItems?.append(itemsPerPageQuery)
            
            return urlComponents?.url
        }
    }
}
