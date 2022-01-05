import Foundation

struct NetworkDataTransfer {
    private let session: URLSession
    private var semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    var isConnected: Bool {
        return getHealthChecker()
    }
    
    init(session: URLSession = URLSession.shared) {
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
        guard let urlRequest = URLRequest(url: OpenMarketURL.healthChecker, method: .get),
              let data = dataTask(request: urlRequest) else {
            return false
        }
        let successResponse = "\"OK\""
        
        return String(data: data, encoding: .utf8) == successResponse
    }
    
    func getProductDetail(id: Int) -> Product? {
        guard isConnected,
              let urlRequest = URLRequest(url: OpenMarketURL.productDetail(id: id), method: .get) else {
                  return nil
              }
        
        let data = dataTask(request: urlRequest)
        let product = JSONParser<Product>().decode(from: data)
        
        return product
    }
    
    func getProductPage(pageNumber: Int, itemsPerPage: Int) -> ProductPage? {
        guard isConnected,
              let urlRequest = URLRequest(url: OpenMarketURL.productPage(pageNumber, itemsPerPage), method: .get) else {
            return nil
        }
        
        let data = dataTask(request: urlRequest)
        let productPage = JSONParser<ProductPage>().decode(from: data)
        
        return productPage
    }
}
