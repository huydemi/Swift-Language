/*
 What’s New in Swift 4?
 https://www.raywenderlich.com/582-what-s-new-in-swift-4
 */

import UIKit

// Strings

let galaxy = "Milky Way 🐮"
for char in galaxy {
  print(char)
}

galaxy.count       // 11
galaxy.isEmpty     // false
galaxy.dropFirst() // "ilky Way 🐮"
String(galaxy.reversed()) // "🐮 yaW ykliM"

// Filter out any none ASCII characters
galaxy.filter { char in
  let isASCII = char.unicodeScalars.reduce(true, { $0 && $1.isASCII })
  return isASCII
} // "Milky Way "

// Grab a subsequence of String
let endIndex = galaxy.index(galaxy.startIndex, offsetBy: 3)
var milkSubstring = galaxy[galaxy.startIndex...endIndex]   // "Milk"
type(of: milkSubstring)   // Substring.Type

// Concatenate a String onto a Substring
milkSubstring += "🥛"     // "Milk🥛"

// Create a String from a Substring
let milkString = String(milkSubstring) // "Milk🥛"

"👩‍💻".count // Now: 1, Before: 2
"👍🏽".count // Now: 1, Before: 2
"👨‍❤️‍💋‍👨".count // Now: 1, Before, 4

//  Dictionary and Set

let nearestStarNames = ["Proxima Centauri", "Alpha Centauri A", "Alpha Centauri B", "Barnard's Star", "Wolf 359"]
let nearestStarDistances = [4.24, 4.37, 4.37, 5.96, 7.78]

// Dictionary from sequence of keys-values
let starDistanceDict = Dictionary(uniqueKeysWithValues: zip(nearestStarNames, nearestStarDistances))
// ["Wolf 359": 7.78, "Alpha Centauri B": 4.37, "Proxima Centauri": 4.24, "Alpha Centauri A": 4.37, "Barnard's Star": 5.96]

// Random vote of people's favorite stars
let favoriteStarVotes = ["Alpha Centauri A", "Wolf 359", "Alpha Centauri A", "Barnard's Star"]

// Merging keys with closure for conflicts
let mergedKeysAndValues = Dictionary(zip(favoriteStarVotes, repeatElement(1, count: favoriteStarVotes.count)), uniquingKeysWith: +) // ["Barnard's Star": 1, "Alpha Centauri A": 2, "Wolf 359": 1]

// Filtering results into dictionary rather than array of tuples
let closeStars = starDistanceDict.filter { $0.value < 5.0 }
closeStars // Dictionary: ["Proxima Centauri": 4.24, "Alpha Centauri A": 4.37, "Alpha Centauri B": 4.37]

// Mapping values directly resulting in a dictionary
let mappedCloseStars = closeStars.mapValues { "\($0)" }
mappedCloseStars // ["Proxima Centauri": "4.24", "Alpha Centauri A": "4.37", "Alpha Centauri B": "4.37"]

// Subscript with a default value
let siriusDistance = mappedCloseStars["Wolf 359", default: "unknown"] // "unknown"

// Subscript with a default value used for mutating
var starWordsCount: [String: Int] = [:]
for starName in nearestStarNames {
  let numWords = starName.split(separator: " ").count
  starWordsCount[starName, default: 0] += numWords // Amazing
}
starWordsCount // ["Wolf 359": 2, "Alpha Centauri B": 3, "Proxima Centauri": 2, "Alpha Centauri A": 3, "Barnard's Star": 2]

// Grouping sequences by computed key
let starsByFirstLetter = Dictionary(grouping: nearestStarNames) { $0.first! }

// ["B": ["Barnard's Star"], "A": ["Alpha Centauri A", "Alpha Centauri B"], "W": ["Wolf 359"], "P": ["Proxima Centauri"]]

// Improved Set/Dictionary capacity reservation
starWordsCount.capacity  // 6
starWordsCount.reserveCapacity(20) // reserves at _least_ 20 elements of capacity
starWordsCount.capacity // 24

//  Private Access Modifier

struct SpaceCraft {
  private let warpCode: String
  
  init(warpCode: String) {
    self.warpCode = warpCode
  }
}

extension SpaceCraft {
  func goToWarpSpeed(warpCode: String) {
    if warpCode == self.warpCode { // Error in Swift 3 unless warpCode is fileprivate
      print("Do it Scotty!")
    }
  }
}

let enterprise = SpaceCraft(warpCode: "KirkIsCool")
//enterprise.warpCode  // error: 'warpCode' is inaccessible due to 'private' protection level
enterprise.goToWarpSpeed(warpCode: "KirkIsCool") // "Do it Scotty!"

//  API Additions

struct CuriosityLog: Codable {
  enum Discovery: String, Codable {
    case rock, water, martian
  }
  
  var sol: Int
  var discoveries: [Discovery]
}

// Create a log entry for Mars sol 42
let logSol42 = CuriosityLog(sol: 42, discoveries: [.rock, .rock, .rock, .rock])

let jsonEncoder = JSONEncoder() // One currently available encoder

// Encode the data
let jsonData = try jsonEncoder.encode(logSol42)
// Create a String from the data
let jsonString = String(data: jsonData, encoding: .utf8) // "{"sol":42,"discoveries":["rock","rock","rock","rock"]}"

let jsonDecoder = JSONDecoder() // Pair decoder to JSONEncoder

// Attempt to decode the data to a CuriosityLog object
let decodedLog = try jsonDecoder.decode(CuriosityLog.self, from: jsonData)
decodedLog.sol         // 42
decodedLog.discoveries // [rock, rock, rock, rock]

//  Key-Value Coding

struct Lightsaber {
  enum Color {
    case blue, green, red
  }
  let color: Color
}

class ForceUser {
  var name: String
  var lightsaber: Lightsaber
  var master: ForceUser?
  
  init(name: String, lightsaber: Lightsaber, master: ForceUser? = nil) {
    self.name = name
    self.lightsaber = lightsaber
    self.master = master
  }
}

let sidious = ForceUser(name: "Darth Sidious", lightsaber: Lightsaber(color: .red))
let obiwan = ForceUser(name: "Obi-Wan Kenobi", lightsaber: Lightsaber(color: .blue))
let anakin = ForceUser(name: "Anakin Skywalker", lightsaber: Lightsaber(color: .blue), master: obiwan)

// Create reference to the ForceUser.name key path
let nameKeyPath = \ForceUser.name

// Access the value from key path on instance
let obiwanName = obiwan[keyPath: nameKeyPath]  // "Obi-Wan Kenobi"

// Use keypath directly inline and to drill down to sub objects
let anakinSaberColor = anakin[keyPath: \ForceUser.lightsaber.color]  // blue

// Access a property on the object returned by key path
let masterKeyPath = \ForceUser.master
let anakinMasterName = anakin[keyPath: masterKeyPath]?.name  // "Obi-Wan Kenobi"

// Change Anakin to the dark side using key path as a setter
anakin[keyPath: masterKeyPath] = sidious
anakin.master?.name // Darth Sidious

// Note: not currently working, but works in some situations
// Append a key path to an existing path
//let masterNameKeyPath = masterKeyPath.appending(path: \ForceUser.name)
//anakin[keyPath: masterKeyPath] // "Darth Sidious"

// Multi-line String Literals

let star = "⭐️"
let introString = """
A long time ago in a galaxy far,
far away....

You could write multi-lined strings
without "escaping" single quotes.

The indentation of the closing quotes
below deside where the text line
begins.

You can even dynamically add values
from properties: \(star)
"""
print(introString) // prints the string exactly as written above with the value of star

// One-Sided Ranges

// Collection Subscript
var planets = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
let outsideAsteroidBelt = planets[4...] // Before: planets[4..<planets.endIndex]
let firstThree = planets[..<4]          // Before: planets[planets.startIndex..<4]

// Infinite range: 1...infinity
var numberedPlanets = Array(zip(1..., planets))
print(numberedPlanets) // [(1, "Mercury"), (2, "Venus"), ..., (8, "Neptune")]

planets.append("Pluto")
numberedPlanets = Array(zip(1..., planets))
print(numberedPlanets) // [(1, "Mercury"), (2, "Venus"), ..., (9, "Pluto")]

// Pattern matching

func temperature(planetNumber: Int) {
  switch planetNumber {
  case ...2: // anything less than or equal to 2
    print("Too hot")
  case 4...: // anything greater than or equal to 4
    print("Too cold")
  default:
    print("Justtttt right")
  }
}

temperature(planetNumber: 3) // Earth

// Generic Subscripts

struct GenericDictionary<Key: Hashable, Value> {
  private var data: [Key: Value]
  
  init(data: [Key: Value]) {
    self.data = data
  }
  
  subscript<T>(key: Key) -> T? {
    return data[key] as? T
  }
}

// Dictionary of type: [String: Any]
var earthData = GenericDictionary(data: ["name": "Earth", "population": 7500000000, "moons": 1])

// Automatically infers return type without "as? String"
let name: String? = earthData["name"]

// Automatically infers return type without "as? Int"
let population: Int? = earthData["population"]

extension GenericDictionary {
  subscript<Keys: Sequence>(keys: Keys) -> [Value] where Keys.Iterator.Element == Key {
    var values: [Value] = []
    for key in keys {
      if let value = data[key] {
        values.append(value)
      }
    }
    return values
  }
}

// Array subscript value
let nameAndMoons = earthData[["moons", "name"]]        // [1, "Earth"]
// Set subscript value
let nameAndMoons2 = earthData[Set(["moons", "name"])]  // [1, "Earth"]

//  MutableCollection.swapAt(_:_:)

// Very basic bubble sort with an in-place swap
func bubbleSort<T: Comparable>(_ array: [T]) -> [T] {
  var sortedArray = array
  for i in 0..<sortedArray.count - 1 {
    for j in 1..<sortedArray.count {
      if sortedArray[j-1] > sortedArray[j] {
        sortedArray.swapAt(j-1, j) // New MutableCollection method
      }
    }
  }
  return sortedArray
}

bubbleSort([4, 3, 2, 1, 0]) // [0, 1, 2, 3, 4]

// Associated Type Constraints

protocol MyProtocol {
  associatedtype Element
  associatedtype SubSequence : Sequence where SubSequence.Iterator.Element == Iterator.Element
}

// Class and Protocol Existential

protocol MyProtocol { }
class View { }
class ViewSubclass: View, MyProtocol { }

class MyClass {
  var delegate: (View & MyProtocol)?
}

let myClass = MyClass()
//myClass.delegate = View() // error: cannot assign value of type 'View' to type '(View & MyProtocol)?'
myClass.delegate = ViewSubclass()

//  Limiting @objc Inference

// NSNumber Bridging

let n = NSNumber(value: 999)
let v = n as? UInt8 // Swift 4: nil, Swift 3: 231











