import XCTest

class JSONParserTests: XCTestCase {
    func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
        guard let path = Bundle.main.path(forResource: "MockProduct", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        let data = jsonString.data(using: .utf8)
        let result = JSONParser<Product>().decode(from: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, 15)
    }
    
    func test_ProductPage타입_decode했을때_Nil이_아닌지_테스트() {
        guard let path = Bundle.main.path(forResource: "MockProductPage", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        let data = jsonString.data(using: .utf8)
        let result = JSONParser<ProductPage>().decode(from: data)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.pageNumber, 1)
    }
}
