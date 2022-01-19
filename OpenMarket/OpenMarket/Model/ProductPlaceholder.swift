import Foundation

enum ProductPlaceholder: String {
    case name = "상품명"
    case price = "상품가격"
    case discountedPrice = "할인금액"
    case stock = "재고수량"
    case description = "제품의 설명을 작성해주세요.\n글자수는 1000자 미만까지 가능합니다.\n\n\n\n\n"
    
    var text: String {
        return self.rawValue
    }
}
