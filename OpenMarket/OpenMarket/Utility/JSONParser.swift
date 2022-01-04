import Foundation

struct JSONParser<Item: Codable> {
    func decode(from json: Data?) -> Item? {
        guard let data = json else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedData = try? decoder.decode(Item.self, from: data)
        
        return decodedData
    }
}
