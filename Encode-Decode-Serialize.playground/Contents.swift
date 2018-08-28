/*
 Encoding, Decoding and Serialization in Swift 4
 https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4
 */

import UIKit

struct Employee: Codable {
  var name: String
  var id: Int
  var favoriteToy: Toy
  
  enum CodingKeys: String, CodingKey {
    case id = "employeeId"
    case name
    case favoriteToy
  }
}

struct Toy: Codable {
  var name: String
}

let toy1 = Toy(name: "Teddy Bear");
let employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)

let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(employee1)

print(jsonData)

let jsonString = String(data: jsonData, encoding: .utf8)
print(jsonString)
// {"name":"John Appleseed","id":7,"favoriteToy":{"name":"Teddy Bear"}}

let jsonDecoder = JSONDecoder()
let employee2 = try jsonDecoder.decode(Employee.self, from: jsonData)

