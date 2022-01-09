import Foundation

extension URLRequest {
    init?(url: URLProtocol, method: HttpMethod) {
        guard let url = url.url else {
            return nil
        }
        self.init(url: url)
        self.httpMethod = method.description
    }
}

enum HttpMethod {
    case get
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
