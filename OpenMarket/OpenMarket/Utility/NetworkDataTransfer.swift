import Foundation

struct NetworkDataTransfer {
    private var url: String
    private var semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    var isConnected: Bool {
        return getHealthChecker()
    }
    
    init(url: String = "https://market-training.yagom-academy.kr/") {
        self.url = url
    }
    
    private func getHealthChecker() -> Bool {
        guard let url = URL(string: "\(self.url)healthChecker") else {
            return false
        }
        var result: Bool = false
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in
            let successStatusCode = 200
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == successStatusCode else {
                      semaphore.signal()
                      return
                  }
            result = true
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
        
        return result
    }
    
    func getProductDetail(id: Int) -> Product? {
        guard isConnected,
              let url = URL(string: "\(self.url)api/products/\(id)") else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        var product: Product?
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            let successStatusCode = 200...299
            
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                      semaphore.signal()
                      return
                  }
            
            product = JSONParser<Product>().decode(from: data)
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
        
        return product
    }
    
    func getProductPage(pageNumber: Int, itemsPerPage: Int) -> ProductPage? {
        guard isConnected else {
            return nil
        }
        
        var urlComponents = URLComponents(string: "\(self.url)api/products?")
        let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
        let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
        urlComponents?.queryItems?.append(pageNumberQuery)
        urlComponents?.queryItems?.append(itemsPerPageQuery)
        
        guard let url: URL = urlComponents?.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        var productPage: ProductPage?
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            let successStatusCode = 200...299
            
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                      semaphore.signal()
                      return
                  }
            
            productPage = JSONParser<ProductPage>().decode(from: data)
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
        
        return productPage
    }
    
    enum CustomError: Error {
        case statusCodeError
        case unknownError
    }

    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      return completionHandler(.failure(.statusCodeError))
                  }
            
            if let data = data {
                return completionHandler(.success(data))
            }
            
            completionHandler(.failure(.unknownError))
        }
        task.resume()
    }
    
    func getUser(id: Int, completionHandler: @escaping (Result<Data, CustomError>) -> Void) {
        
        guard let url = URL(string: self.url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
