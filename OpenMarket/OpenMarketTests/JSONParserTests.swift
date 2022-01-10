import XCTest
@testable import OpenMarket

class JSONParserTests: XCTestCase {
    func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "MockProduct", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
                  XCTFail()
                  return
              }
        
        let data = jsonString.data(using: .utf8)
        let result = try? JSONParser<Product>().decode(from: data).get()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, 15)
    }
    
    func test_ProductPage타입_decode했을때_Nil이_아닌지_테스트() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "MockProductPage", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
                  XCTFail()
                  return
              }
        
        let data = jsonString.data(using: .utf8)
        let result = try? JSONParser<ProductPage>().decode(from: data).get()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.pageNumber, 1)
    }
}
