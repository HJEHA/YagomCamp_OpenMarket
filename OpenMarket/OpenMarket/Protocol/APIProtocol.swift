import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
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
