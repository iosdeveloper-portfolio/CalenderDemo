

import Foundation
class AppointManager {
    static var shared: AppointManager = AppointManager()
    var appointments: [AppoinmentModel] = []
    
    init() {
        
    }
    
    func append(_ newObject: AppoinmentModel) {
        AppointManager.shared.appointments.append(newObject)
    }
}
