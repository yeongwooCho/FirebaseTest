//
//  ViewController.swift
//  FirebaseTest
//
//  Created by 조영우 on 2021/05/01.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numOfCustomers: UILabel!
    let db: DatabaseReference! = Database.database(url: "https://fir-test-fae7a-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLoad()
        saveBasicTypes()
        saveCustomers()
        fetchCustomers()
        
//        updateBasicTypes()
        deleteBasicTypes()
    }
    
    func updateLoad() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            let firstData = snapshot.value as? String ?? ""
            
            DispatchQueue.main.async {
                self.dataLabel.text = firstData
            }
        }
    }
}

extension ViewController {
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
}

// MARK: Read(fetch) data
extension ViewController {
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

extension ViewController {
//    db.child("int").setValue(3)
//    db.child("double").setValue(3.5)
//    db.child("string").setValue("string value - 안녕")
    func updateBasicTypes() {
        db.updateChildValues(["int": 4])
        db.updateChildValues(["double": 4.1])
        db.updateChildValues(["string": "변경된 스트링"])
    }
    
    func deleteBasicTypes() {
        db.child("int").removeValue()
        db.child("double").removeValue()
        db.child("string").removeValue()
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

