

import UIKit

//MARK: - String Extension
extension String {
    func isStringWithoutSpace() -> Bool{
        return !self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}

extension Date {
    func toStringWithDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toStringdatewithTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        return dateFormatter.string(from: self)
    }
    
}

