import XCTest

class NetworkDataTransferTests: XCTestCase {
    func test_isConnected가_정상작동_하는지() {
        let result = NetworkDataTransfer().isConnected
        
        XCTAssertTrue(result)
    }
    
    func test_getProductDetail가_정상작동_하는지() {
        let result = NetworkDataTransfer().getProductDetail(id: 2)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.id, 2)
    }
    
    func test_getProductPage가_정상작동_하는지() {
        let result = NetworkDataTransfer().getProductPage(pageNumber: 1, itemsPerPage: 10)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.pageNumber, 1)
        XCTAssertEqual(result!.itemsPerPage, 10)
    }
}
