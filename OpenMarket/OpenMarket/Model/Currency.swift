import Foundation

enum Currency: String, Codable, CustomStringConvertible, CaseIterable {
    case koreanWon = "KRW"
    case unitedStatesDollar = "USD"
    
    var description: String {
        return rawValue
    }
}
