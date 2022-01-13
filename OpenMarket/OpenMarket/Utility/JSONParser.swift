import Foundation

enum JSONParserError: Error, LocalizedError {
    case decodingFail
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패했습니다."
        }
    }
}

struct JSONParser<Item: Codable> {
    func decode(from json: Data?) -> Result<Item, JSONParserError> {
        guard let data = json else {
            return .failure(.decodingFail)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let decodedData = try? decoder.decode(Item.self, from: data) else {
            return .failure(.decodingFail)
        }
        
        return .success(decodedData)
    }
}
