import Foundation
import UIKit

struct OpenMarketBaseURL: BaseURLProtocol {
    var baseURL = "https://market-training.yagom-academy.kr/"
}

struct HealthCheckerAPI: Gettable {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)healthChecker")
    }
}

struct ProductDetailAPI: Gettable {
    var url: URL?
    var method: HttpMethod = .get
    
    init(id: Int, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)api/products/\(id)")
    }
}

struct ProductPageAPI: Gettable {
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

struct ProductRegisterAPI: Postable {
    var url: URL?
    var method: HttpMethod = .post
    var identifier: String = "54dee239-7217-11ec-abfa-2f78db105e0f" // 허황
//    var identifier: String = "cd706a3e-66db-11ec-9626-796401f2341a" // 야곰꺼
    var contentType: String
    var body: Data?
    
    init<Item: Codable>(params: String, item: Item, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)api/products")
        
        var multipartFormData = MultipartFormData()
        self.contentType = "multipart/form-data; boundary=\(multipartFormData.boundary)"
        
        let productRegisterData = multipartFormData.createFormData(params: params, item: item)
        multipartFormData.appendToBody(from: productRegisterData)
        guard let image = UIImage(systemName: "plus") else {
            return
        }
        let imageData = multipartFormData.createImageFormData(name: "images",
                                                              filename: "Test.png",
                                                              contentType: .png, image: image)
        multipartFormData.appendToBody(from: imageData)
        
        multipartFormData.closeBody()
        
        self.body = multipartFormData.body
    }
}
