/*
 Encoding, Decoding and Serialization in Swift 4
 https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4
 */

import UIKit

struct Employee {
  var name: String
  var id: Int
  var favoriteToy: Toy
  
  enum CodingKeys: String, CodingKey {
    case id = "employeeId"
    case name
    case gift
  }
}

struct Toy: Codable {
  var name: String
}

extension Employee: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(id, forKey: .id)
    try container.encode(favoriteToy.name, forKey: .gift)
  }
}

extension Employee: Decodable {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    id = try values.decode(Int.self, forKey: .id)
    let gift = try values.decode(String.self, forKey: .gift)
    favoriteToy = Toy(name: gift)
  }
}

let toy1 = Toy(name: "Teddy Bear");
let employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)

let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(employee1)

print(jsonData)

let jsonString = String(data: jsonData, encoding: .utf8)
print(jsonString)

let jsonDecoder = JSONDecoder()
let employee2 = try jsonDecoder.decode(Employee.self, from: jsonData)
