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
    
    private func dataTask(request: URLRequest) -> Data {
        var resultData = Data()
        
        let task = session.dataTask(with: request) { data, response, _ in
            let successStatusCode = 200
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == successStatusCode else {
                      semaphore.signal()
                      return
                  }
            
            if let data = data {
                resultData = data
                semaphore.signal()
                return
            }
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
        
        let data = dataTask(request: urlRequest)
        let successResponse = "\"OK\""
        return String(data: data, encoding: .utf8) == successResponse
    }
}
