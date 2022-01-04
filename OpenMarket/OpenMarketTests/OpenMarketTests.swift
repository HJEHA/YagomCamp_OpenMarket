import XCTest

class OpenMarketTests: XCTestCase {    
    func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
        let result = JSONParser<Product>().decode(from: MockProduct.json)
        
        XCTAssertNotNil(result)
    }
    
    func test_Product타입_decode했을때_id가_일치하는지_테스트() {
        let result = JSONParser<Product>().decode(from: MockProduct.json)
        
        XCTAssertEqual(result?.id, 15)
    }
    
    func test_ProductPage타입_decode했을때_Nil이_아닌지_테스트() {
        let result = JSONParser<ProductPage>().decode(from: MockProductPage.json)
        
        XCTAssertNotNil(result)
    }
    
    func test_ProductPage타입_decode했을때_pageNumber가_일치하는지_테스트() {
        let result = JSONParser<ProductPage>().decode(from: MockProductPage.json)
        
        XCTAssertEqual(result?.pageNumber, 1)
    }
}
