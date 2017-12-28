
import UIKit

class SaveSetting: NSObject, NSCoding {

    //MARK: Properties
    var u: Double
    var v: Double
    var nA: Double
    var dZeroA: Int
    var nB: Double
    var dZeroB: Int
    var nC: Double
    var dZeroC: Int
    var nD: Double
    var dZeroD: Int
    
    //MARK: Types
    init?(u: Double, v: Double,
          nA: Double, dZeroA: Int,
          nB: Double, dZeroB: Int,
          nC: Double, dZeroC: Int,
          nD: Double, dZeroD: Int
        ) {
        
        // The name must not be empty
        guard !u.isZero else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard !v.isZero else {
            return nil
        }
        
        guard !nA.isZero else {
            return nil
        }
        
        guard !(dZeroA == 0) else {
            return nil
        }
        guard !nB.isZero else {
            return nil
        }
        
        guard !(dZeroB == 0) else {
            return nil
        }
        guard !nC.isZero else {
            return nil
        }
        
        guard !(dZeroC == 0) else {
            return nil
        }
        guard !nD.isZero else {
            return nil
        }
        
        guard !(dZeroD == 0) else {
            return nil
        }
        
        // Initialize stored properties.
        self.u = Double(u)
        self.v = Double(v)
        self.dZeroA = Int(dZeroA)
        self.nA = Double(nA)
        self.dZeroB = Int(dZeroB)
        self.nB = Double(nB)
        self.dZeroC = Int(dZeroC)
        self.nC = Double(nC)
        self.dZeroD = Int(dZeroD)
        self.nD = Double(nD)
    }

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(u, forKey: Setting.u)
        aCoder.encode(v, forKey: Setting.v)
        aCoder.encode(nA, forKey: Setting.nA)
        aCoder.encode(dZeroA, forKey: Setting.dZeroA)
        aCoder.encode(nB, forKey: Setting.nB)
        aCoder.encode(dZeroB, forKey: Setting.dZeroB)
        aCoder.encode(nC, forKey: Setting.nC)
        aCoder.encode(dZeroC, forKey: Setting.dZeroC)
        aCoder.encode(nD, forKey: Setting.nD)
        aCoder.encode(dZeroD, forKey: Setting.dZeroD)
    }
    
    struct Setting {
        static let u = "2"
        static let v = "2"
        static let nA = String(Constants._n)
        static let dZeroA = String(Constants._dZero)
        static let nB = String(Constants._n)
        static let dZeroB = String(Constants._dZero)
        static let nC = String(Constants._n)
        static let dZeroC = String(Constants._dZero)
        static let nD = String(Constants._n)
        static let dZeroD = String(Constants._dZero)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let u = aDecoder.decodeDouble(forKey: Setting.u)
        let v = aDecoder.decodeDouble(forKey: Setting.v)
        let nA = aDecoder.decodeDouble(forKey: Setting.nA)
        let dZeroA = aDecoder.decodeInteger(forKey: Setting.dZeroA)
        let nB = aDecoder.decodeDouble(forKey: Setting.nB)
        let dZeroB = aDecoder.decodeInteger(forKey: Setting.dZeroB)
        let nC = aDecoder.decodeDouble(forKey: Setting.nC)
        let dZeroC = aDecoder.decodeInteger(forKey: Setting.dZeroC)
        let nD = aDecoder.decodeDouble(forKey: Setting.nD)
        let dZeroD = aDecoder.decodeInteger(forKey: Setting.dZeroD)
        self.init(u: u, v: v,
                  nA:nA, dZeroA:dZeroA,
                  nB:nB, dZeroB:dZeroB,
                  nC:nC, dZeroC:dZeroC,
                  nD:nD, dZeroD:dZeroD)
    }
    

    
}


