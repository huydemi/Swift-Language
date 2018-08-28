/**
 Copyright (c) 2016 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

struct Checkerboard {
  
  enum Square: String {
    case empty = "▪️"
    case red = "🔴"
    case white = "⚪️"
  }
  
  typealias Coordinate = (x: Int, y: Int)
  
  fileprivate var squares: [[Square]] = [
    [ .empty, .red,   .empty, .red,   .empty, .red,   .empty, .red   ],
    [ .red,   .empty, .red,   .empty, .red,   .empty, .red,   .empty ],
    [ .empty, .red,   .empty, .red,   .empty, .red,   .empty, .red   ],
    [ .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty ],
    [ .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty ],
    [ .white, .empty, .white, .empty, .white, .empty, .white, .empty ],
    [ .empty, .white, .empty, .white, .empty, .white, .empty, .white ],
    [ .white, .empty, .white, .empty, .white, .empty, .white, .empty ]
  ]
  
  subscript(coordinate: Coordinate) -> Square {
    get {
      return squares[coordinate.y][coordinate.x]
    }
    set {
      squares[coordinate.y][coordinate.x] = newValue
    }
  }
  
  subscript(x: Int, y: Int) -> Square {
    get {
      return self[(x: x, y: y)]
    }
    set {
      self[(x: x, y: y)] = newValue
    }
  }
}

extension Checkerboard: CustomStringConvertible {
  
  var description: String {
    return squares.map { row in row.map { $0.rawValue }.joined(separator: "") }
        .joined(separator: "\n") + "\n"
  }
}

var checkerboard = Checkerboard()
print(checkerboard)

let coordinate = (x: 3, y: 2)
print(checkerboard[coordinate])
checkerboard[coordinate] = .white
print(checkerboard)

print(checkerboard[1, 2])
checkerboard[1, 2] = .white
print(checkerboard)
