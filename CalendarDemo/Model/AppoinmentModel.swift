

import Foundation
class AppoinmentModel {
    var dateString: String?
    var description: String?
    
    init(date: String, description: String) {
        self.dateString = date
        self.description = description
    }
}
