import XCTest
@testable import OpenMarket

class NetworkDataTransferTests: XCTestCase {
    func test_getHealthChecker가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "getHealthChecker 비동기 테스트")
        
        NetworkDataTransfer().getHealthChecker { result in
            switch result {
            case .success(let data):
                let resultString = String(data: data, encoding: .utf8)
                let successString = #""OK""#
                XCTAssertEqual(resultString, successString)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getProductDetail가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "getProductDetail 비동기 테스트")
        
        NetworkDataTransfer().getProductDetail(id: 2) { result in
            switch result {
            case .success(let data):
                let product = try? JSONParser<Product>().decode(from: data).get()
                XCTAssertEqual(product?.id, 2)
                XCTAssertEqual(product?.name, "팥빙수")
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_getProductPage가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "getProductPage 비동기 테스트")
        
        NetworkDataTransfer().getProductPage(pageNumber: 1, itemsPerPage: 10) { result in
            switch result {
            case .success(let data):
                let productPage = try? JSONParser<ProductPage>().decode(from: data).get()
                XCTAssertEqual(productPage?.pageNumber, 1)
                XCTAssertEqual(productPage?.itemsPerPage, 10)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
  
    func test_MockURLSession의_StatusCode가_200번일때_정상동작_하는지() {
        let mockSession = MockURLSession(isRequestSuccess: true)
        let netWorkDataTransfer = NetworkDataTransfer(session: mockSession)

        let expectation = XCTestExpectation(description: "MockURLSession의 getHealthChecker 비동기 테스트")
        
        netWorkDataTransfer.getHealthChecker { result in
            switch result {
            case .success(let data):
                let resultString = String(data: data, encoding: .utf8)
                let successString = #""OK""#
                XCTAssertEqual(resultString, successString)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_MockURLSession의_StatusCode가_200번이_아닐때_실패하는지() {
        let mockSession = MockURLSession(isRequestSuccess: false)
        let netWorkDataTransfer = NetworkDataTransfer(session: mockSession)

        let expectation = XCTestExpectation(description: "MockURLSession의 getHealthChecker 비동기 테스트")

        netWorkDataTransfer.getHealthChecker { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.statusCodeError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
