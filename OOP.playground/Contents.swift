/*
 Object Oriented Programming in Swift
 https://www.raywenderlich.com/599-object-oriented-programming-in-swift
 */

import UIKit

class Music {
  let notes: [String]
  
  init(notes: [String]) {
    self.notes = notes
  }
  
  func prepared() -> String {
    return notes.joined(separator: " ")
  }
}

// 1
class Instrument {
  // 2
  let brand: String
  // 3
  init(brand: String) {
    //4
    self.brand = brand
  }
  
  func tune() -> String {
    fatalError("Implement this method for \(brand)")
  }
  
  func play(_ music: Music) -> String {
    return music.prepared()
  }

  func perform(_ music: Music) {
    print(tune())
    print(play(music))
  }


}

// 1
class Piano: Instrument {
  let hasPedals: Bool
  // 2
  static let whiteKeys = 52
  static let blackKeys = 36
  
  // 3
  init(brand: String, hasPedals: Bool = false) {
    self.hasPedals = hasPedals
    // 4
    super.init(brand: brand)
  }
  
  // 5
  override func tune() -> String {
    return "Piano standard tuning for \(brand)."
  }
  
  override func play(_ music: Music) -> String {
    // 6
    let preparedNotes = super.play(music)
    return "Piano playing \(preparedNotes)"
  }
}



