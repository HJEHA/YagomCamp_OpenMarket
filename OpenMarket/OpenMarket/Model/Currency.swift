import Foundation

enum Currency: String, Codable, CustomStringConvertible {
    case koreanWon = "KRW"
    case unitedStatesDollar = "USD"
    
    var description: String {
        return rawValue
    }
}
