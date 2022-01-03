import Foundation

struct JSONParser<Item: Codable> {
    func decode(from json: String) -> Item? {
        guard let jsonData = json.data(using: .unicode) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedData = try? decoder.decode(Item.self, from: jsonData)
        
        return decodedData
    }
}
