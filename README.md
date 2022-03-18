# 오픈 마켓 프로젝트

## 개요

### 프로젝트 목표 
#### HTTP 통신, 컬렉션 뷰를 활용하여 마켓 앱 구현

### 프로젝트 기간
#### 2022.01.03 ~ 2022.01.31

### 프로젝트 기술 스택
<img width="200" src="https://i.imgur.com/miX5aY0.png">

### 프로젝트 Pull Request
|STEP 1|STEP 2|STEP 3|STEP 4|
|---|---|---|---|
|[링크](https://github.com/yagom-academy/ios-open-market/pull/84)|[링크](https://github.com/yagom-academy/ios-open-market/pull/96)|[링크](https://github.com/yagom-academy/ios-open-market/pull/114)|[링크](https://github.com/yagom-academy/ios-open-market/pull/131)|

## 앱 구동 화면
### 상품 리스트 화면
|리스트 형식|그리드 형식|
|---|---|
|<img width="200" src="https://i.imgur.com/74YoME0.gif">|<img width="200" src="https://i.imgur.com/6VhIBOw.gif">|


### 상품 등록 화면
|이미지 추가|이미지 수정/삭제|상품 등록 실패|상품 등록 성공|키보드 입력 처리|
|---|---|---|---|---|
|<img width="200" src="https://i.imgur.com/KsqBnFP.gif">|<img width="200" src="https://i.imgur.com/QoqzYq6.gif">|<img width="200" src="https://i.imgur.com/pcxnzgE.gif">|<img width="200" src="https://i.imgur.com/k1mBXL0.gif">|<img width="200" src="https://i.imgur.com/0Llsy78.gif">|


## 트러블 슈팅
### 네트워크에 의존하지 않는 URLSession Unit Test
> `URLSessionProtocol`, `MockURLSession`을 이용한 네트워크 테스트를 진행했습니다. `MockURLSession`을 구현한 이유는 `MockURLSession` 없이 실제 서버와 통신하면 테스트의 속도가 느려지며, 인터넷 연결상태에 따라 테스트 결과가 달라지므로 테스트 결과를 신뢰할 수 없기 때문입니다. 또한 실제 서버와 통신하면 의도치 않게 서버에 테스트 데이터를 업로드 하는 등 side-effect가 발생할 수 있습니다. 

### 서버 데이터를 비동기로 Load하는 방법

> Trouble Shooting 과정은 아래 순서로 진행했습니다.
> 1) semaphore 사용 전
    - URLSession이 데이터 Loading 작업을 비동기로 처리하므로 `getHealthChecker` 메서드의 반환값 반영이 안되는 문제가 발생했습니다. 이를 해결하기 위해 semaphore를 활용해 반환 값을 받기 전까지 다른 스레드의 접근을 차단하는 방식을 사용했습니다.
> 2) semaphore 사용 후
    - 반환타입이 있으면 MockURLSession을 통한 테스트가 불가능한 문제가 발생했습니다. 따라서 `getHealthChecker` 메서드의 매개변수 타입을 탈출클로저로 변경하고, semaphore를 삭제하고 메서드의 반환 타입을 변경했습니다. 그리고 이 방식을 다른 GET 관련 메서드들에 적용했습니다.
> 3) semaphore 삭제, `탈출 클로저` 및 `Result<Data, Error>` 사용
> ```swift
> // 수정 전 - semaphore 및 반환타입 사용
> let semaphore = DispatchSemaphore(value: 0)
> 
> private func getHealthChecker() -> Bool {
>     guard let url = URL(string: "\(self.url)healthChecker") else {
>         return false
>     }
>     var result: Bool = false
> 
>     var urlRequest = URLRequest(url: url)
>     urlRequest.httpMethod = "GET"
> 
>     let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in 
>         let successStatusCode = 200
> 
>         guard let httpResponse = response as? HTTPURLResponse,
>               httpResponse.statusCode == successStatusCode else {
>                   semaphore.signal()
>                   return
>               }
>         result = true  // data 존재 유무를 로컬변수에 할당
>         semaphore.signal()
>     }
>     dataTask.resume()
>     semaphore.wait()
> 
>     return result   
> }
> ```

> ```swift
> // 수정 후 - 함수 분리 후 탈출 클로저 사용
> private func loadData(request: URLRequest, completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
>     let task = session.dataTask(with: request) { data, response, _ in
>         ...
>     }
>     task.resume()
> }
> 
> func getHealthChecker(completionHandler: @escaping ((Result<Data, NetworkError>) -> Void)) {
>     guard let urlRequest = URLRequest(url: OpenMarketURL.healthChecker, method: .get) else {
>         return
>     }
>     loadData(request: urlRequest, completionHandler: completionHandler)
> }
> ```


### List(목록형), Grid(격자형) 두가지 형태의 Cell을 대응하는 방법
> 여러 가지 방법을 찾아봤습니다.
> + Modern Collection View : iOS 14이상에서 사용할 수 있는 방법으로 프로젝트 최소 빌드 타켓이 iOS 13.2이기 때문에 사용하지 못했습니다.
> + 컬렉션 뷰 레이아웃을 두개 구성하고 스위치하는 방법 (기존 Flow Layout 사용)
> + 두 가지 형태의 커스텀 셀을 구성하고 cellForItemAt 메서드에서 셀을 스위치하는 방법
> + 리스트 형태는 테이블 뷰, 그리드 형태는 콜렉션 뷰로 구현
> 
> 두 가지 형태의 커스텀 셀을 구성하고 셀의 크기에 따라 `UICollectionViewDelegateFlowLayout`를 사용해 두 가지 형태의 셀을 전부 대응할 수 있도록 구현했습니다.

### Image Cache
> 상품의 Thumbnail을 매번 서버에서 요청받아 화면에 띄우는건 비효율적이고 비용도 크다는 생각을 했습니다.
> 따라서 NSCache를 이용한 메모리 캐시를 도입했습니다.
> Thumbnail의 URL을 key로 하고 먼저 메모리에 해당 키를 가진 Thumbnail이 있는지 확인합니다.
> 메모리에 이미지가 존재한다면 이미지를 반환해주고, 존재하지 않는다면 서버에 요청해 이미지를 받아옵니다. 
> 이때 성공적으로 이미지를 받아왔다면 메모리에 이미지를 캐시에 저장해서 다음번에 이미지를 사용하는 경우 캐시에서 이미지를 받아올 수 있도록 했습니다.
   

### 화면 전환 시 Scroll 위치 유지
> 사용자가 최근 확인한 상품을 화면 전환 시 그대로 볼 수 있게 하기 위해 Scroll 위치를 유지하도록 구현하고자 했습니다. 하지만 List 화면에서 Grid 화면으로 전환 시, Grid 화면의 `Scroll Indicator`가 다소 아래로 내려가 있는 문제가 발생했습니다. 이를 해결하기 위해 List/Gird 화면 각각의 전체 높이에 대한 화면 전환 이전의 `Scroll Indicator`의 상대적인 위치를 고려하여 Scroll Offset을 지정하도록 개선했습니다. (수식 `화면전환 이후의 Scroll Indicator의 위치 = 화면전환 이후의 화면 높이 * 현재 Scroll Indicator의 상대적인 위치`을 활용)
>    
> ```swift 
> private func currentScrollRatio() -> CGFloat {
>     return productCollectionView.contentOffset.y / productCollectionView.contentSize.height  // 현재 화면 전체 높이에 대한 Scroll Indicator의 상대적인 위치
> }
> 
> private func syncScrollIndicator(with currentScrollRatio: CGFloat) {
>     let nextViewMaxHeight = productCollectionView.contentSize.height
>     let offset = CGPoint(x: 0, y: nextViewMaxHeight * currentScrollRatio)  // 화면전환 이후의 Scroll Indicator의 위치 = 화면전환 이후의 화면 높이 * 현재 Scroll Indicator의 상대적인 위치
>     productCollectionView.setContentOffset(offset, animated: false)
> }
> ```
   
### 화면 전환 시 애니메이션 버그
> 화면이 전환될 때 아래 gif처럼 스크롤 과정의 잔상이 보이는 문제가 발생했습니다.  
> |개선 전|개선 후|
> |-|-|
> |![](https://i.imgur.com/AjHBJhJ.gif)|![](https://i.imgur.com/0CK2D01.gif)|
> 
> reloadData() 메서드는 completion을 별도로 지니고 있지 않기 때문에 기존에는 performBatchUpdates 메서드를 사용했습니다. 하지만
> performBatchUpdates 메서드를 잘못 사용한 것이 원인이었습니다. 
> performBatchUpdates 메서드는 Collection View의 여러 애니메이션들을 수행하고, 그에 따른 Completion을 동작시켜주는 메서드입니다.
> 기존 방법으로 performBatchUpdates의 매개변수인 updates 클로저 내부에서 reloadData() 메서드를 호출했고, completion 클로저에서 스크롤을 움직이라는 코드를 배치했습니다.
> 하지만 위와 같은 버그가 발생했습니다.
> 
> 개선 방법   
> performBatchUpdates 메서드 대신 reloadData() 메서드의 완료를 알 수 있는 또 다른 방법을 활용했습니다.
> reloadData가 호출되면 아래 순서에 따라 코드가 실행됩니다.
> 1. numberOfItemsInSection 메서드에서 Cell의 개수를 결정
> 2. cellForItemAt 메서드에서 화면에 보여질 만큼의 Cell을 생성
> 3. collection View의 layoutSubViews 호출
> 
> 즉, reloadData 메서드가 완료되면 layoutSubViews 메서드가 호출됩니다. 이에 따라 커스텀 Collection View 클래스를 만들고 아래의 메서드와 프로퍼티를 추가했습니다. 
> 또한 UX 개선을 위해 Fade in/out 기능을 추가적으로 구현했습니다.
> ```swift
> var reloadDataCompletionHandler: (() -> Void)?
>     
> func reloadDataCompletion(_ completion: @escaping () -> Void) {
>     reloadDataCompletionHandler = completion
>     super.reloadData()
> }
>    
> override func layoutSubviews() {
>     super.layoutSubviews()
>     if let handler = reloadDataCompletionHandler {
>         handler()
>         reloadDataCompletionHandler = nil
>     }
> }
>     
> func fadeIn(withDuration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
>     UIView.animate(withDuration: 0.5, animations: {
>         self.alpha = 1
>     }, completion: completion)
> }
> 
> func fadeOut(withDuration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
>     UIView.animate(withDuration: 0.5, animations: {
>         self.alpha = 0
>     }, completion: completion)
> }
> ```   
