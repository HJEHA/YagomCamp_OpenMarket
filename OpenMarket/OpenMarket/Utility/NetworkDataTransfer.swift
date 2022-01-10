import Foundation

enum NetworkError: Error {
    case statusCodeError
    case unknownError
    case urlIsNil
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
    
    func request(api: APIProtocol, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let urlRequest = URLRequest(api: api) else {
            completionHandler(.failure(.urlIsNil))
            return
        }

        loadData(request: urlRequest, completionHandler: completionHandler)
    }
}
