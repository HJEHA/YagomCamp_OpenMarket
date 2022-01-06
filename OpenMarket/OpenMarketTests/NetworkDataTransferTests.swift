import XCTest
@testable import OpenMarket

class NetworkDataTransferTests: XCTestCase {
    func test_getHealthChecker가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "getHealthChecker 비동기 테스트")
        
        NetworkDataTransfer().getHealthChecker { result in
            switch result {
            case .success(let data):
                let rusultString = String(data: data, encoding: .utf8)
                let successString = #""OK""#
                XCTAssertEqual(rusultString, successString)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
//    func test_getProductDetail가_정상작동_하는지() {
//        let result = NetworkDataTransfer().getProductDetail(id: 2)
//
//        XCTAssertNotNil(result)
//        XCTAssertEqual(result!.id, 2)
//    }
//
//    func test_getProductPage가_정상작동_하는지() {
//        let result = NetworkDataTransfer().getProductPage(pageNumber: 1, itemsPerPage: 10)
//
//        XCTAssertNotNil(result)
//        XCTAssertEqual(result!.pageNumber, 1)
//        XCTAssertEqual(result!.itemsPerPage, 10)
//    }
//
//    func test_MockURLSession의_StatusCode가_200번이_아닐때_실패하는지() {
//        let mockSession = MockURLSession(isRequestSuccess: false)
//        let netWorkDataTransfer = NetworkDataTransfer(session: mockSession)
//        mockSession.semaphore = netWorkDataTransfer.semaphore
//
//        let result = netWorkDataTransfer.isConnected
//
//        XCTAssertFalse(result)
//    }
}
