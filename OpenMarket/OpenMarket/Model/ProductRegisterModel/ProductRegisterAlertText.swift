import Foundation

enum AddProductImageActionSheetText: String {
    case addImageAlertTitle = "업로드할 사진을 선택해주세요"
    case editImageAlertTitle = "수정할 사진을 선택해주세요"
    case library = "앨범에서 가져오기"
    case camera = "사진 촬영"
    case cancel = "취소"
    case cameraDisableAlertTitle = "카메라를 사용할 수 없음"
    case confirm = "확인"
    
    var description: String {
        return self.rawValue
    }
}

enum ProductRegisterAlertText: String {
    case successTitle = "상품 등록이 완료되었습니다"
    case failTitle = "상품 등록에 실패했습니다"
    case imageFailMessage = "이미지는 최소 1장 이상 추가해주세요."
    case nameFailMessage = "상품명을 3글자 이상, 100글자 이하로 입력해주세요."
    case emptyPriceMessage = "상품가격을 입력해주세요."
    case discountedPriceFailMessage = "가격을 다시 확인해주세요."
    case stockFailMessage = "상품 수량을 0 이상으로 입력해주세요."
    case descriptionFailMessage = "상품 설명은 10글자 이상, 1000글자 이하로 작성해주세요."
    case confirm = "확인"
    
    var description: String {
        return self.rawValue
    }
}
