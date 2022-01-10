import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url)
        self.httpMethod = "\(api.method)"
    }
}

enum HttpMethod: CustomStringConvertible {
    case get
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
