import Foundation

struct MultipartFormData {
    private let boundary: String
    let contentType: String
    var body: Data = Data()
    init() {
        let uuid = UUID()
        self.boundary = "Boundary-\(uuid.uuidString)"
        self.contentType = "multipart/form-data; boundary=\(self.boundary)"
    }
    
    mutating func appendToBody(from data: Data) {
        self.body.append(data)
    }
    
    func createFormData<Item: Codable>(params: String, item: Item) -> Data {
        var data = Data()
        data.append(BoundaryGenerator.boundaryData(forBoundaryType: .startSymbol, boundary: boundary))
        data.append(ContentDisposition.formData(params: params).bodyComponent)
        
        let encodedResult = JSONParser<Item>().encode(from: item)
        switch encodedResult {
        case .success(let encodedData):
            data.append(encodedData)
        case .failure(let error):
            print(error.localizedDescription)
        }
        data.append(BoundaryGenerator.boundaryData(forBoundaryType: .endSymbol, boundary: boundary))
        
        return data
    }
}

enum ContentDisposition {
    case formData(params: String)
    case imageFormData(name: String, filename: String)
    case imageContentType(type: String)
    
    var bodyComponent: String {
        switch self {
        case .formData(let params):
            return "Content-Disposition: form-data; name=\"\(params)\""
                    + EncodingCharacters.doubleNewLine
        case .imageFormData(let name, let filename):
            return "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\""
                    + EncodingCharacters.newLine
        case .imageContentType(let type):
            return "Content-Type: \(type)" + EncodingCharacters.doubleNewLine
        }
    }
}

enum EncodingCharacters {
    static let newLine = "\r\n"
    static let doubleNewLine = "\r\n\r\n"
}

enum BoundaryGenerator {
    enum BoundaryType {
        case startSymbol, endSymbol, terminator
    }
    
    static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
        let boundaryText: String
        
        switch boundaryType {
        case .startSymbol:
            boundaryText = "--\(boundary)\(EncodingCharacters.newLine)"
        case .endSymbol:
            boundaryText = "\(EncodingCharacters.newLine)"
        case .terminator:
            boundaryText = "\(EncodingCharacters.newLine)--\(boundary)--"
        }
        
        return Data(boundaryText.utf8)
    }
}

private extension Data {
    mutating func append(_ string: String?) {
        if let stringData = string?.data(using: .utf8) {
            self.append(stringData)
        }
    }
}
