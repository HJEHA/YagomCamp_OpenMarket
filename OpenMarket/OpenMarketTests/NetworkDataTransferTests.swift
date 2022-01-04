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
}
