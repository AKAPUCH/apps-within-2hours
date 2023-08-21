

import Foundation

struct Expense : Codable {
    var kind : String?
    var amount : Int = 0
    var desc : String?
}
