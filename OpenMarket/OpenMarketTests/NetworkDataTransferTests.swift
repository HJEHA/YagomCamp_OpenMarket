import XCTest

class NetworkDataTransferTests: XCTestCase {
    func test_isConnected가_정상작동_하는지() {
        let result = NetworkDataTransfer().isConnected
        
        XCTAssertTrue(result)
    }
}
