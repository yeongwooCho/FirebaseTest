# FirebaseTest

### Firebase 란?

앱을 만들다 보면 서버와의 Networking을 하는 경우가 많이 생기고, 서버를 만들어야 되는 경우가 존재한다.
이제는 서버를 서비스로 제공하는 것이 존재하고 이는 google의 Firebase이다.
firebase를 이용하면 따로 서버를 구축하지 않아도 다음과 같은 기능을 사용할 수 있다.
> 데이터저장, 실시간 데이터 동기화, 사용자 인증, 데이터 분석, A/B Testing(제품의 성장을 위한), 등등등등

<br><br>

### firebase는 3가지 축으로 서비스를 도와주고 있다.
> 더 잘만들도록, 앱 퀄리티를 높게, 비지니스적 성장 3가지 이다.

1. 더 잘 만들도록 : 개발 속도를 높히는 서버관련 기능들을 제공한다. 
사용자 인증, 호스팅, 클라우드 저장소, 머신러닝 백엔드 서비스, 실시간 DB 등등

2. 앱 퀄리티를 높게: 앱 crash를 잘 관찰해 어디서 문제가 나는지 확인 할 수 있는 기능, 앱의 성능 모니터링, testing

3. 비지니스 성장 관련: 돈벌게 해주는 것
A/B Testing로 고객의 반응을 실험, 이벤트 로깅을 통한 분석 Analytics, 웹에서 설정하는 값에 따라서 사용자에게 다양한 경험을 시켜주는 remote config

 
+ 고객에 대한 정보를 알 수 있다.
+ 여러가지 기능이 있을때 “어떤 행동 뒤에는 어떤 행동을 한다” 라는 것을 통계로 보여준다.
+ StreanView 실시간 사용자를 보여준다.
+ A/B Testing
+ Crashlytics 앱의 안정성 확인

<br><br>

### 설치

Firebase IOS SDK를 프로젝트 안에 설치하면 된다.
SDK( Software Development Kit ) —> 개발도구라고 생각하면 된다.
Firebase를 사용하기 위한 기능들을 구글 개발자들이 만들어놨다. 우리는 가져와서 사용만 하면 된다.
Firebase IOS SDK는 Firebase를 IOS에 접목하기 위한 소프트웨어 개발 바구니 이다.

<br><br>

### Data Read
~~~
let db: DatabaseReference! = Database.database(url: "https://fir-test-fae7a-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()

class ViewController {
    let db: DatabaseReference! = Database.database().reference()
    
    func fetchCustomers() {
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            print("--> snapshot value: \(snapshot.value)")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                print("--> customer count: \(customers.count)")
                DispatchQueue.main.async {
                    self.numOfCustomers.text = "num of customers: \(customers.count)"
                }
            } catch let error {
                print("--> error: \(error.localizedDescription)")
            }
        }
    }
}

struct Customer: Codable {
    let id: String
    let name: String
    let books: [Book]
    
    var toDictionary: [String: Any] {
        let booksArray = books.map { $0.toDictionary }
        return ["id": id, "name": name, "books": booksArray]
    }
    
    static var id: Int = 0
}

struct Book: Codable {
    let title: String
    let author: String
    
    var toDictionary: [String: Any] {
        return ["title": title, "author": author]
    }
}



~~~

<br><br>

### Date Write

~~~
func saveBasicTypes() {
// Firebase child("key").setValue(value)
// 가능한 타입: string, number, dict, array

   db.child("int").setValue(3)
   db.child("double").setValue(3.5)
   db.child("string").setValue("string value - 안녕")
   db.child("array").setValue(["a", "b", "c"])
   db.child("dict").setValue(["id": "anyID", "age": 10, "city": "busan"])
}

func saveCustomers() {
   let books: [Book] = [Book(title: "습관의 디테일", author: "포그"), Book(title: "생각정리스킬", author: "복주환")]

   let customer1 = Customer(id: "\(Customer.id)", name: "Son", books: books)
   Customer.id += 1
   let customer2 = Customer(id: "\(Customer.id)", name: "Dele", books: books)
   Customer.id += 1
   let customer3 = Customer(id: "\(Customer.id)", name: "Kane", books: books)
   Customer.id += 1

   db.child("customers").child(customer1.id).setValue(customer1.toDictionary)
   db.child("customers").child(customer2.id).setValue(customer2.toDictionary)
   db.child("customers").child(customer3.id).setValue(customer3.toDictionary)
}
~~~

<br><br>

### Data Update

~~~
func updateBasicTypes() {
   db.updateChildValues(["int": 4])
   db.updateChildValues(["double": 4.1])
   db.updateChildValues(["string": "변경된 스트링"])
}
~~~

<br><br>

### Data Delete

~~~
func deleteBasicTypes() {
   db.child("int").removeValue()
   db.child("double").removeValue()
   db.child("string").removeValue()
}
~~~

<br><br>
