import Foundation

struct URLSessionFactory {
    private let baseURL: String
    private let session: URLSession
    private var semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    var isConnected: Bool {
        return getHealthChecker()
    }
    
    init(url: String = "https://market-training.yagom-academy.kr/",
         session: URLSession = URLSession.shared) {
        self.baseURL = url
        self.session = session
    }
    
    private func dataTask(request: URLRequest) -> Data? {
        var resultData: Data?
        
        let task = session.dataTask(with: request) { data, response, _ in
            let successStatusCode = 200..<300
            
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                      semaphore.signal()
                      return
                  }
            
            resultData = data
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        return resultData
    }
    
    func getHealthChecker() -> Bool {
        guard let url = URL(string: "\(baseURL)healthChecker") else {
            return false
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        guard let data = dataTask(request: urlRequest) else {
            return false
        }
        let successResponse = "\"OK\""
        
        return String(data: data, encoding: .utf8) == successResponse
    }
    
    func getProductDetail(id: Int) -> Product? {
        guard isConnected,
              let url = URL(string: "\(self.baseURL)api/products/\(id)") else {
                  return nil
              }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let data = dataTask(request: urlRequest)
        let product = JSONParser<Product>().decode(from: data)
        
        return product
    }
    
    func getProductPage(pageNumber: Int, itemsPerPage: Int) -> ProductPage? {
        guard isConnected else {
            return nil
        }
        
        var urlComponents = URLComponents(string: "\(self.baseURL)api/products?")
        let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
        let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
        urlComponents?.queryItems?.append(pageNumberQuery)
        urlComponents?.queryItems?.append(itemsPerPageQuery)
        
        guard let url: URL = urlComponents?.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let data = dataTask(request: urlRequest)
        let productPage = JSONParser<ProductPage>().decode(from: data)
        
        return productPage
    }
}
