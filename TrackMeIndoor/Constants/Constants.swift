import CoreLocation
import UIKit

class Constants{
    
    
    static let counter : Int = 8
    
    
    
    static let u : Double = 2.0
    static let v : Double = 2.0
    static let distanceUnit : Double = u/8

    
    //     a
    //  b     d   u
    //     c
    
    
    static let uuid: UUID = UUID(uuidString: "B5b182c7-eab1-4988-aa99-b5c1517008d9")!
    static let iBeaconMajor: Int = 1
    static let firendMajor: Int = 2
    static let identifier = "trackMeIndoor"
    
//    struct BeaconA{
//        static let name: String = "A"
//        static let minor: Int = 58633
//    }
//    struct BeaconB{
//        static let name: String = "B"
//        static let minor: Int = 59655
//
//    }
//    struct BeaconC{
//        static let name: String = "C"
//        static let minor: Int = 53000
//    }
//    struct BeaconD{
//        static let name: String = "D"
//        static let minor: Int = 47625
//    }
//    
    struct beaconsInfo {
        static let name = ["A", "B", "C", "D", "E", "F", "G", "H"]
        static let minor = [58633, 59655, 53000, 47625, 1, 2, 3, 4]
        static let color = [UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.brown.cgColor]
        static let nodeID = [1, 3, 7, 10, 14, 18, 22, 28]
        static let nodeDescription = ["Room 924B","Room 924A","Toilet","Room 901", "F5 Lift Lobby","Room 505", "Foyer", "Room 508"]
        
    }
    

    
    static let findMyLocationCoordinate = [[u/2, 0.0], [0.0,v/2], [u/2,v], [u,v/2]]

    static let findSeatBeaconCoordinate = [[0.0, u/2], [v/2,0.0], [v,u/2], [v/2,u]]
        
    
//    struct VU_Distance {
//        var u: Double = 0.0
//        var v: Double = 0.0
//        init(_ u: Double, _ v: Double) {
//            self.v = v
//            self.u = u
//        }
//    }
}
