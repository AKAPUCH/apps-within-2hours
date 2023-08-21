

import Foundation

struct Expense {
    var kind : String?
    var amount : Int = 0
    var desc : String?
}

protocol Shape {
    func describe() -> String
}

struct Square: Shape {
    func describe() -> String {
        return "I'm a square. My four sides have the same lengths."
    }
    func makeShape() -> Shape {
      return Circle()
    }
}

struct Circle: Shape {
    func describe() -> String {
        return "I'm a circle. I look like a perfectly round apple pie."
    }
}


