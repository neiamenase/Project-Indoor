import CoreLocation

class Constants{
    
    
    static let counter : Int = 12
    
    
    static let u : Double = 2.0
    static let v : Double = 2.0
    static let distanceUnit : Double = u/8

    
    //     a
    //  b     d
    //     c
    
    static let major: Int = 1
    static let uuid: UUID = UUID(uuidString: "B5b182c7-eab1-4988-aa99-b5c1517008d9")!
    
    struct BeaconA{
        static let name: String = "A"
        static let minor: Int = 58633
        static let locationX : Double = 4.5
        static let locationY : Double = 0.5
    }
    struct BeaconB{
        static let name: String = "B"
        static let minor: Int = 59655
        static let locationX : Double = 0.5
        static let locationY : Double = 4.5
    }
    struct BeaconC{
        static let name: String = "C"
        static let minor: Int = 53000
        static let locationX : Double = 8.5
        static let locationY : Double = 4.5
    }
    struct BeaconD{
        static let name: String = "D"
        static let minor: Int = 47625
        static let locationX : Double = 4.5
        static let locationY : Double = 8.5
    }
    
//    struct VU_Distance {
//        var u: Double = 0.0
//        var v: Double = 0.0
//        init(_ u: Double, _ v: Double) {
//            self.v = v
//            self.u = u
//        }
//    }
}
