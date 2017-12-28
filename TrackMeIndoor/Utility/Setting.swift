
import UIKit

class SaveSetting: NSObject, NSCoding {

    //MARK: Properties
    var u: Double
    var v: Double
    var n: Double
    var dZero: Int
    
    //MARK: Types
    init?(u: Double, v: Double, n: Double, dZero: Int) {
        
        // The name must not be empty
        guard !u.isZero else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard !v.isZero else {
            return nil
        }
        
        guard !n.isZero else {
            return nil
        }
        
        guard !(dZero == 0) else {
            return nil
        }
        
        // Initialize stored properties.
        self.u = Double(u)
        self.v = Double(v)
        self.dZero = Int(dZero)
        self.n = Double(n)
    }

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(u, forKey: Setting.u)
        aCoder.encode(v, forKey: Setting.v)
        aCoder.encode(n, forKey: Setting.n)
        aCoder.encode(dZero, forKey: Setting.dZero)
    }
    
    struct Setting {
        static let u = "2"
        static let v = "2"
        static let n = String(Constants._n)
        static let dZero = String(Constants._dZero)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let u = aDecoder.decodeDouble(forKey: Setting.u)
        let v = aDecoder.decodeDouble(forKey: Setting.v)
        let n = aDecoder.decodeDouble(forKey: Setting.n)
        let dZero = aDecoder.decodeInteger(forKey: Setting.dZero)
        self.init(u: u, v: v, n:n, dZero:dZero)
    }
    

    
}


