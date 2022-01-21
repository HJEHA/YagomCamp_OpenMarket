import UIKit

struct UserInputChecker {
    func checkImage(_ images: [UIImage]) -> Bool {
        return images.count >= 1
    }
    
    func checkName(_ name: String) -> Bool {
        return name.count >= 3 && name.count <= 1000
    }
    
    func checkDescription(_ description: String) -> Bool {
        if description.count >= 10,
           description.count <= 1000,
           (description == ProductPlaceholder.description.text) == false {
            return true
        }
        
        return false
    }
    
    func checkDiscountedPrice(discountedPrice: Double, price: Double) -> Bool {
        return price >= discountedPrice
    }
}
