
import UIKit

class SaveSetting: NSObject, NSCoding {

    //MARK: Properties
    var u: Double
    var v: Double
    
    //MARK: Types
    init?(u: Double, v: Double) {
        
        // The name must not be empty
        guard !u.isZero else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard !v.isZero else {
            return nil
        }
        
        // Initialize stored properties.
        self.u = Double(u)
        self.v = Double(v)
        
    }

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(u, forKey: Setting.u)
        aCoder.encode(v, forKey: Setting.v)
    }
    
    struct Setting {
        static let u = "2"
        static let v = "2"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let u = aDecoder.decodeDouble(forKey: Setting.u)
        let v = aDecoder.decodeDouble(forKey: Setting.v)
        self.init(u: u, v: v)
    }
    

    
}


