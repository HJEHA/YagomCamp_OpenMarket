import Foundation

enum NetworkError: Error {
    case statusCodeError
    case unknownError
}

struct NetworkDataTransfer {
    private let session: URLSessionProtocol
        
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    private func loadData(request: URLRequest, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
        let task = session.dataTask(with: request) { data, response, _ in
            let successStatusCode = 200..<300
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                      completionHandler(.failure(.statusCodeError))
                      return
                  }
            
            if let data = data {
                completionHandler(.success(data))
                return
            }
            
            completionHandler(.failure(.unknownError))
        }
        task.resume()
    }
    
    func getHealthChecker(completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let urlRequest = URLRequest(url: OpenMarketURL.healthChecker, method: .get) else {
            return
        }
        loadData(request: urlRequest, completionHandler: completionHandler)
    }
    
    func getProductDetail(id: Int, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let urlRequest = URLRequest(url: OpenMarketURL.productDetail(id: id), method: .get) else {
            return
        }

        loadData(request: urlRequest, completionHandler: completionHandler)
    }

    func getProductPage(pageNumber: Int,
                        itemsPerPage: Int,
                        completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let urlRequest = URLRequest(url: OpenMarketURL.productPage(pageNumber, itemsPerPage),
                                          method: .get) else {
            return
        }

        loadData(request: urlRequest, completionHandler: completionHandler)
    }
}
