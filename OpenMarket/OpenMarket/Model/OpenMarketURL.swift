import Foundation

struct OpenMarketBaseURL: BaseURLProtocol {
    var baseURL = "https://market-training.yagom-academy.kr/"
}

struct HealthCheckerAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)healthChecker")
    }
}

struct ProductDetailAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(id: Int, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)api/products/\(id)")
    }
}

struct ProductPageAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(pageNumber: Int, itemsPerPage: Int, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        var urlComponents = URLComponents(string: "\(baseURL.baseURL)api/products?")
        let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
        let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
        urlComponents?.queryItems?.append(pageNumberQuery)
        urlComponents?.queryItems?.append(itemsPerPageQuery)
        
        self.url = urlComponents?.url
    }
}
