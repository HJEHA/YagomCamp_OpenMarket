import Foundation

extension URLRequest {
    init?(url: URLProtocol, method: HttpMethod) {
        guard let url = url.url else {
            return nil
        }
        self.init(url: url)
        
        switch method {
        case .get:
            self.httpMethod = "GET"
        }
    }
}

enum HttpMethod {
    case get
}
