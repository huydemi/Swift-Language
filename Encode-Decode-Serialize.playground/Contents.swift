/*
 Encoding, Decoding and Serialization in Swift 4
 https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4
 */

import UIKit

struct Employee: Codable {
  var name: String
  var id: Int
  var favoriteToy: Toy
}

struct Toy: Codable {
  var name: String
}
