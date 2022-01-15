import Foundation

enum NetworkError: Error, LocalizedError {
    case statusCodeError
    case unknownError
    case urlIsNil

    var errorDescription: String? {
        switch self {
        case .statusCodeError:
            return "정상적인 StatusCode가 아닙니다."
        case .unknownError:
            return "알수 없는 에러가 발생했습니다."
        case .urlIsNil:
            return "정상적인 URL이 아닙니다."
        }
    }
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
    
    func fetchData<T: Codable>(api: APIProtocol,
                               decodingType: T.Type,
                               completionHandler: @escaping ((_ data: T) -> Void)) {
        request(api: api) { result in
            switch result {
            case .success(let data):
                let decodedData = JSONParser<T>().decode(from: data)
                
                switch decodedData {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
