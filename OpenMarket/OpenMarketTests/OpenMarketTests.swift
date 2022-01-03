import XCTest

class OpenMarketTests: XCTestCase {    
    func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
        let result = JSONParser<Product>().decode(from: MockProduct.json)
        
        XCTAssertNotNil(result)
    }
}
