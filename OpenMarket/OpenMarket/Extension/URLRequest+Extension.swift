import Foundation

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url)
        self.httpMethod = "\(api.method)"
        
        if let postablAPI = api as? Postable {
            self.addValue(postablAPI.identifier, forHTTPHeaderField: "identifier")
            self.addValue(postablAPI.contentType, forHTTPHeaderField: "Content-Type")
            self.httpBody = postablAPI.body
        }
    }
}
