import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

protocol Gettable: APIProtocol { }

protocol Postable: APIProtocol {
    var identifier: String { get }
    var contentType: String { get }
    var body: Data? { get set }
}

enum HttpMethod: CustomStringConvertible {
    case get
    case post
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
