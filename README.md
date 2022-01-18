# 오픈 마켓 프로젝트
## 프로젝트 소개
- STEP 3/4 확인 후 작성 예정

## 목차
- [STEP1 : 모델/네트워킹 타입 구현](##STEP1-모델/네트워킹-타입-구현)
    + [키워드](#1-1-키워드)
    + [구현 내용](#1-2-구현-내용)
    + [고민한 점](#1-3-고민한-점)
    + [Trouble Shooting](#1-4-Trouble-Shooting)
    + [피드백 반영](#1-5-피드백-반영)

## STEP1 모델/네트워킹 타입 구현
### 1-1 키워드
* 네트워크 : URLSession, HTTP Request/Response, 서버 API 문서
* 비동기 작업 : completionHandler, escaping closure
* Unit Test : Mock Data/Mock URLSession, XCTestExpectation
* 라이브러리 : Swift Lint, CocoaPods
* JSON : Decoding, CodingKey, convertFromSnakeCase

### 1-2 구현 내용
Parsing한 JSON 데이터를 Mapping할 Model 타입을 설계했습니다. 그리고 서버와 통신하기 위해 URLSession을 활용했습니다. Mock Data 및 Mock URLSession을 통해 이에 대한 Unit Test를 진행했습니다.

**프로젝트 구조**
- Extension
    - URLRequest+Extension : URL을 만들 때 HttpMethod까지 지정할 수 있도록 init() 추가
    - URLSession+Extension : 네트워크 없이 테스트를 진행하기 위한 URLSessionProtocol을 정의하고 URLSession 확장하여 채택함.
- Utility
    - JSONParser : JSON 데이터를 사용자 정의 타입으로 decode하기 위한 구조체 타입
    - NetworkDataTransfer : 서버와 데이터 통신을 하기 위한 구조체 타입
- Model
    - Product : 상품 상세 정보를 담는 모델 타입
    - Currency : 상품 통화(나라별 화폐 단위) 정보를 담는 열거형 타입
    - Image : 상품의 이미지 정보를 담는 모델 타입
    - Vendor : 판매자 정보를 담는 모델 타입
    - ProductPage : 상품 페이지 정보를 담는 모델 타입
    - OpenMarketURL : OpenMarket 프로젝트에서 사용하는 URL를 관리하는 네임스페이스
- Unit Test 
    - MockProduct.json / MockProductPage.json : 가짜 상품/페이지 정보 관련 json 데이터
    - MockURLSession : 네트워크 없이 테스트를 진행하기 위한 MockURLSession 타입. URLSessionProtocol 채택
    - JSONParserTests :  JSONParser 타입을 테스트 하기 위한 테스트 코드. 가짜 json 데이터를 사용함.
    - NetworkDataTransferTests : 서버와 통신을 하기 위한 테스트 코드. 네트워크 통신 없이 MockURLSession을 활용한 테스트 진행

### 1-3 고민한 점
**1. `convertFromSnakeCase` 및 `CodingKeys` 사용**
convertFromSnakeCase를 사용하여 JSON Data의 SnakeCase로 된 parameter 이름을 Swift에서 CamelCase로 사용하도록 했습니다. 이때 convertFromSnakeCase가 처리할 수 없는 부분이 있었는데, 예를 들어 `page_no`는 Swift로 변환했을 때 `pageNo`이 아니라 `pageNumber`이 되어야 하므로 `CodingKey`를 함께 적용했습니다.
 
**2. Unit Test를 위해 `JSON 파일` 및 `MockURLSession` 사용**
Swift 파일에 JSON String을 넣는 방법도 가능하지만, 향후 테스트할 대상 파일이 늘어날 것에 대비하여 JSON 파일 자체를 만들고 `Bundle.main.path`를 활용하여 데이터에 접근하는 방법을 사용했습니다.

`URLSessionProtocol`, `MockURLSession`을 이용한 네트워크 테스트를 진행했습니다. `MockURLSession`을 구현한 이유는 `MockURLSession` 없이 실제 서버와 통신하면 테스트의 속도가 느려지며, 인터넷 연결상태에 따라 테스트 결과가 달라지므로 테스트 결과를 신뢰할 수 없기 때문입니다. 또한 실제 서버와 통신하면 의도치 않게 서버에 테스트 데이터를 업로드 하는 등 side-effect가 발생할 수 있습니다. 

### 1-4 Trouble Shooting
**서버 데이터를 비동기로 Load하는 방법**

Trouble Shooting 과정은 아래 순서로 진행했습니다.
1) semaphore 사용 전
    - URLSession이 데이터 Loading 작업을 비동기로 처리하므로 `getHealthChecker` 메서드의 반환값 반영이 안되는 문제가 발생했습니다. 이를 해결하기 위해 semaphore를 활용해 반환 값을 받기 전까지 다른 스레드의 접근을 차단하는 방식을 사용했습니다.
2) semaphore 사용 후
    - 반환타입이 있으면 MockURLSession을 통한 테스트가 불가능한 문제가 발생했습니다. 따라서 `getHealthChecker` 메서드의 매개변수 타입을 탈출클로저로 변경하고, semaphore를 삭제하고 메서드의 반환 타입을 변경했습니다. 그리고 이 방식을 다른 GET 관련 메서드들에 적용했습니다.
3) semaphore 삭제, `탈출 클로저` 및 `Result<Data, Error>` 사용
```swift
// 수정 전 - semaphore 및 반환타입 사용
let semaphore = DispatchSemaphore(value: 0)

private func getHealthChecker() -> Bool {
    guard let url = URL(string: "\(self.url)healthChecker") else {
        return false
    }
    var result: Bool = false

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"

    let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in 
        let successStatusCode = 200

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == successStatusCode else {
                  semaphore.signal()
                  return
              }
        result = true  // data 존재 유무를 로컬변수에 할당
        semaphore.signal()
    }
    dataTask.resume()
    semaphore.wait()

    return result   
}

// 수정 후 - 함수 분리 후 탈출 클로저 사용
private func loadData(request: URLRequest, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
    let task = session.dataTask(with: request) { data, response, _ in
        let successStatusCode = 200..<300
        guard let httpResponse = response as? HTTPURLResponse,
              successStatusCode.contains(httpResponse.statusCode) else {
                  completionHandler(.failure(.statusCodeError))
                  return
              }

        if let data = data {
            completionHandler(.success(data))  // data를 completionHandler에 전달
            return
        }

        completionHandler(.failure(.unknownError))
    }
    task.resume()
}

func getHealthChecker(completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
    guard let urlRequest = URLRequest(url: OpenMarketURL.healthChecker, method: .get) else {
        return
    }
    loadData(request: urlRequest, completionHandler: completionHandler)
}

// MockURLSession 관련 테스트 코드
class NetworkDataTransferTests: XCTestCase {
    func test_MockURLSession의_StatusCode가_200번일때_정상동작_하는지() {
        let mockSession = MockURLSession(isRequestSuccess: true)
        let netWorkDataTransfer = NetworkDataTransfer(session: mockSession)

        let expectation = XCTestExpectation(description: "MockURLSession의 getHealthChecker 비동기 테스트")
        
        netWorkDataTransfer.getHealthChecker { result in  // 탈출 클로저가 있어야 실행 가능한 구조
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
}
```

### 1-5 피드백 반영
**1. URLProtocol / OpenMarketURL 관련**
기존 방식은 아래의 문제점을 가질 수 있습니다.
* API가 추가될 경우 열거형의 크기가 점점 비대해집니다.
* 여러 개발자가 동시에 OpenMarketURL 파일을 수정할 때 충돌이 발생할 수 있습니다.
* 새로운 API가 추가될 경우 case를 계속 생성하고 switch문을 매번 수정해야 합니다.

```swift
// 개선 전 코드
protocol URLProtocol {  
    var url: URL? { get }
}

extension URLRequest {
    init?(url: URLProtocol, method: HttpMethod) {
        guard let url = url.url else {
            return nil
        }
        self.init(url: url)
        self.httpMethod = method.description
    }
}

enum OpenMarketURL: URLProtocol {   
    private static let apiHost = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case productDetail(id: Int)
    case productPage(_ pageNumber: Int, _ itemsPerPage: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: "\(OpenMarketURL.apiHost)healthChecker")
        case .productDetail(let id):
            return URL(string: "\(OpenMarketURL.apiHost)api/products/\(id)")
        case .productPage(let pageNumber, let itemsPerPage):
            var urlComponents = URLComponents(string: "\(OpenMarketURL.apiHost)api/products?")
            let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
            let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            urlComponents?.queryItems?.append(pageNumberQuery)
            urlComponents?.queryItems?.append(itemsPerPageQuery)
            
            return urlComponents?.url
        }
    }
}
```

**개선 방향**   
기존 URL 프로퍼티만 가지던 URLProtocol을 HttpMethod까지 가진 APIProtocol로 변경했습니다.
서버와 통신하기 위한 API 별로 구조체 타입을 새로 생성하고 APIProtocol을 채택했습니다.
이렇게 개선하게 되면 새로운 API가 추가되더라도 기존의 코드를 수정할 필요가 없어집니다.
또, 여러 개발자들이 각자 맞은 API 구조체 타입만 만들면 되기 때문에 충돌이 일어날 확률도 줄어듭니다.
```swift 
// 개선 후 코드
protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url) 
        self.httpMethod = "\(api.method)"
    }
}

struct HealthCheckerAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)healthChecker")
    }
}

struct ProductDetailAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(_ id: Int, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)api/products/\(id)")
    }
}
```

**2. decode 메서드 반환타입 개선**   
decoding 결과를 명확히 나타내기 위해 `decode` 메서드의 반환타입을 옵셔널 `Item?`에서 `Result<Item, JSONParserError>`로 개선했습니다. Result는 `제네릭 열거형`으로 구현되어 있으며, decoding 성공 시 `Item` 타입의 decoding된 데이터를 반환하고, 실패 시 열거형으로 구현한 `Error` 타입을 반환합니다.

```swift  
// 개선 전 코드
func decode(from json: Data?) -> Item? {
    guard let data = json else {
        return nil
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let decodedData = try? decoder.decode(Item.self, from: data)

    return decodedData
}

// 개선 후 코드
func decode(from json: Data?) -> Result<Item, JSONParserError> {
    guard let data = json else {
        return .failure(.decodingFail)
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let decodedData = try? decoder.decode(Item.self, from: data) else {
        return .failure(.decodingFail)
    }

    return .success(decodedData)
}
```

**3. JSONParserTests의 Bundle.main.path 관련 문제 해결**   
decode 메서드에 대한 테스트를 진행하기 위해 `Bundle.main.path`를 통해 MockProduct JSON 데이터에 접근하도록 했는데, path에 nil이 반환되며 Bundle에 접근하지 못하는 문제가 발생했습니다. LLDB 확인 결과 JSON 파일이 포함된 Bundle은 `OpenMarketTests.xctest`이며, 테스트 코드를 실행하는 주체는 OpenMarket `App Bundle`임을 파악했습니다. (LLDB 내용: `OpenMarket.app/PlugIns/OpenMarketTests.xctest`)
따라서 현재 executable의 Bundle 개체를 반환하는 `Bundle.main` (즉, App Bundle)이 아니라, 테스트 코드를 실행하는 주체를 가르키는 `Bundle(for: type(of: self))` (즉, XCTests Bundle)로 path를 수정하여 JSON 파일에 접근할 수 있었습니다.

```swift
// 개선 전 코드
func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
    guard let path = Bundle.main.path(forResource: "MockProduct", ofType: "json"),  // path에 nil이 반환되는 문제 발생
          let jsonString = try? String(contentsOfFile: path) else {
        return
    }
    //...
}

// 개선 후 코드
func test_Product타입_decode했을때_Nil이_아닌지_테스트() {
    guard let path = Bundle(for: type(of: self)).path(forResource: "MockProduct", ofType: "json"),
          let jsonString = try? String(contentsOfFile: path) else {
              XCTFail()
              return
          }
    //...
}
```

이외에도 테스트 코드 내부에서 옵셔널 바인딩을 하는 경우 else문 내부에 `XCTFail()`을 추가하여 예상 결과값이 반환되지 않았음에도 테스트를 Pass 하는 문제를 방지했습니다.
