/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

// Getting Started
enum RideCategory: String {
  case family
  case kids
  case thrill
  case scary
  case relaxing
  case water
}

typealias Minutes = Double
struct Ride {
  let name: String
  let categories: Set<RideCategory>
  let waitTime: Minutes
}

extension RideCategory: CustomStringConvertible {
  var description: String {
    return rawValue
  }
}

extension Ride: CustomStringConvertible {
  var description: String {
    return "⚡️Ride(name: \"\(name)\", waitTime: \(waitTime), categories: \(categories))"
      .replacingOccurrences(of: "RideCategory", with: "")
  }
}


// Immutability and Side Effects
var x = 3
// other stuff...
x = 4

let parkRides = [
  Ride(name: "Raging Rapids", categories: [.family, .thrill, .water], waitTime: 45.0),
  Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
  Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
  Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
  Ride(name: "Thunder Coaster", categories: [.family, .thrill], waitTime: 60.0),
  Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
  Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
  Ride(name: "Mountain Railroad", categories: [.family, .relaxing], waitTime: 0.0)
]

// parkRides[0] = Ride(name: "Functional Programming", categories: [.thrill], waitTime: 5.0) // Error!

// Modularity
print("***Modularity***\n")
func sortedNamesImperative(of rides: [Ride]) -> [String] {
  var sortedRides = rides
  
  for i in 0..<sortedRides.count {
    let key = sortedRides[i]
    
    // Insertion sort
    for j in stride(from: i, through: 0, by: -1) {
      if key.name.localizedCompare(sortedRides[j].name) == .orderedAscending {
        sortedRides.remove(at: j + 1)
        sortedRides.insert(key, at: j)
      }
    }
  }
  
  var sortedNames: [String] = []
  for ride in sortedRides {
    sortedNames.append(ride.name)
  }
  
  return sortedNames
}

// Functional implementation
func sortedNames(of rides: [Ride]) -> [String] {
  let rideNames = parkRides.map { $0.name }
  return rideNames.sorted(by: <)
}

print(sortedNames(of: parkRides))

var originalNames = [String]()
for ride in parkRides {
  originalNames.append(ride.name)
}

print(originalNames)

// First-Class and Higher-Order functions
print("\n***First-Class and Higher-Order functions***\n")
func hasShortWaitTime(ride: Ride) -> Bool {
  return ride.waitTime < 15.0
}

//let shortWaitTimeRides = parkRides.filter(hasShortWaitTime)
//print(shortWaitTimeRides)

let shortWaitTimeRides = parkRides.filter { $0.waitTime < 15.0 }
print(shortWaitTimeRides)

let rideNames = parkRides.map { $0.name }
print(rideNames)

print(rideNames.sorted(by: <))

let totalWaitTime = parkRides.reduce(0) { (total, ride) in total + ride.waitTime }
print(totalWaitTime)

// Partial Functions
print("\n***Partial Functions***\n")
func filter(for category: RideCategory) -> ([Ride]) -> [Ride] {
  return { (rides: [Ride]) in
    rides.filter { $0.categories.contains(category) }
  }
}

let kidRideFilter = filter(for: .kids)
print(kidRideFilter(parkRides))

// Pure Functions
print("\n***Pure Functions***\n")
func ridesWithWaitTimeUnder(_ waitTime: Minutes, from rides: [Ride]) -> [Ride] {
  return rides.filter { $0.waitTime < waitTime }
}

var shortWaitRides = ridesWithWaitTimeUnder(15, from: parkRides)
assert(shortWaitRides.count == 2, "Count of short wait rides should be 2")
print(shortWaitRides)

// Referential Transparency
print("\n***Referential Transparency***\n")
shortWaitRides = parkRides.filter { $0.waitTime < 15 }
assert(shortWaitRides.count == 2, "Count of short wait rides should be 2")
print(shortWaitRides)

// Recursion
print("\n***Recursion***\n")
extension Ride: Comparable {
  static func <(lhs: Ride, rhs: Ride) -> Bool {
    return lhs.waitTime < rhs.waitTime
  }
  
  static func ==(lhs: Ride, rhs: Ride) -> Bool {
    return lhs.name == rhs.name
  }
}

extension Array where Element: Comparable {
  func quickSorted() -> [Element] {
    if self.count > 1 {
      let (pivot, remaining) = (self[0], dropFirst())
      let lhs = remaining.filter { $0 <= pivot }
      let rhs = remaining.filter { $0 > pivot }
      return lhs.quickSorted() as [Element] + [pivot] + rhs.quickSorted()
    }
    return self
  }
}
print(parkRides.quickSorted())
print(parkRides)

// Imperative vs Declarative Code Style
print("\n***Imperative vs Declarative Code Style***\n")
var ridesOfInterest: [Ride] = []
for ride in parkRides where ride.waitTime < 20 {
  for category in ride.categories where category == .family {
    ridesOfInterest.append(ride)
    break
  }
}

var sortedRidesOfInterest = ridesOfInterest.quickSorted()
print(sortedRidesOfInterest)

// Functional Approach
print("\n***Functional Approach***\n")
sortedRidesOfInterest = parkRides.filter { $0.categories.contains(.family) && $0.waitTime < 20 }.sorted(by: <)
print(sortedRidesOfInterest)
