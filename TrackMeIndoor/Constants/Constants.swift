import CoreLocation
import UIKit

class Constants{
    
    //static let counter : Int = 8
    static var u : Double = 2.0
    static var v : Double = 2.0
    static let distanceUnit : Double = 0.5
    
    
    static let n : [Double] = [3.010299957, 3.010299957, 3.010299957, 3.010299957]
    static let dZero : [Int] = [-71, -71,-71, -71]
    

    
    //     a
    //  b     d   u
    //     c
    
    
    static let uuid: UUID = UUID(uuidString: "B5b182c7-eab1-4988-aa99-b5c1517008d9")!
    static let iBeaconMajor: Int = 1
    static let firendMajor: Int = 2
    //static let identifier = "trackMeIndoor"
    
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
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let SettingArchiveURL = DocumentsDirectory.appendingPathComponent("setting")
    struct beaconsInfo {
        static let nodeDescription = ["A", "B", "C", "D", "E", "F", "G", "H", "I","J","K",]
        static let minor = [58633, 59655, 53000, 47625, 1, 2, 3, 4, 5, 6, 7]
        static let color = [UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.brown.cgColor]
        static let nodeID = [1, 19, 7, 10, 15, 3, 23, 29, 34, 37, 39]
        static let name = ["Room 924B","Room 505","Toilet","Room 901", "F5 Lift Lobby","Room 924A", "Foyer", "Room 508","GF Entrance Lobby", "Car Park", "ERB 4F Entrance"]
        
    }
    
    enum NodeType : String {
        case Restaurant, Facility, Clothing, None
        static let allValues = [None, Restaurant, Facility, Clothing]
    }
    
    
    //0:nodeID, 1:name, 2:category, 3: floor, 4:is feature point? 
    static let storesDB =
        [["1",  "Rm 924B", NodeType.Restaurant.rawValue,"9", "1"],
         ["2",  "Terrace Right Entrance", NodeType.Facility.rawValue,"9", "1"],
         ["3",  "Rm 924A", NodeType.Restaurant.rawValue,"9", "1"],
         ["4",  "Rm 922", NodeType.Clothing.rawValue,"9", "1"],
         ["5",  "Rm 921", NodeType.Clothing.rawValue,"9", "1"],
         ["6",  "Terrace Left Entrance", NodeType.Facility.rawValue,"9", "1"],
         ["7",  "F9 Toilet", NodeType.Facility.rawValue,"9", "1"],
         ["8",  "Rm 904", NodeType.Clothing.rawValue,"9", "1"],
         ["9",  "Rm 913 Left Entrance", NodeType.Restaurant.rawValue,"9", "1"],
         ["10", "Rm 901", NodeType.Clothing.rawValue,"9", "1"],
         ["11", "Rm 913 Right Entrance", NodeType.Restaurant.rawValue,"9", "1"],
         ["12", "F9 Lift Lobby", NodeType.None.rawValue,"9", "1"],
         ["13", "Corridor", NodeType.None.rawValue,"9", "0"],
         ["14", "F9 Cargo Lift Lobby", NodeType.None.rawValue,"9", "1"],
         ["15",  "F5 Lift Lobby", NodeType.None.rawValue,"5", "1"],
         ["16",  "Corridor", NodeType.None.rawValue,"5", "0"],
         ["17",  "Rm 503", NodeType.Clothing.rawValue,"5", "1"],
         ["18",  "Rm 504", NodeType.Restaurant.rawValue,"5", "1"],
         ["19",  "Rm 505", NodeType.Restaurant.rawValue,"5", "1"],
         ["20",  "Covered Terrace Entrance", NodeType.None.rawValue,"5", "0"],
         ["21",  "Covered Treace", NodeType.Facility.rawValue,"5", "1"],
         ["22",  "Covered Terrace Entrance", NodeType.None.rawValue,"5", "0"],
         ["23",  "Foyer", NodeType.Facility.rawValue,"5", "1"],
         ["24",  "Foyer Entrance", NodeType.None.rawValue,"5", "0"],
         ["25",  "Corner", NodeType.None.rawValue,"5", "0"],
         ["26",  "Stair Entrance", NodeType.None.rawValue,"5", "0"],
         ["27",  "Foyer to Rm 508", NodeType.None.rawValue,"5", "0"],
         ["28",  "Rm 508 Inner Left Entrance", NodeType.Restaurant.rawValue,"5", "0"],
         ["29",  "Rm 508", NodeType.Restaurant.rawValue,"5", "1"],
         ["30",  "Rm 508 Inner Right Entrance", NodeType.Restaurant.rawValue,"5", "0"],
         ["31",  "Foyer to Rm 508", NodeType.None.rawValue,"5", "0"],
         ["32",  "F5 Cargo Lift Lobby", NodeType.None.rawValue,"5", "1"],
         ["33",  "GF Lift Lobby", NodeType.None.rawValue,"0", "1"],
         ["34",  "GF Entrance Lobby", NodeType.Facility.rawValue,"0", "1"],
         ["35",  "Cargo Lift Lobby Entrance", NodeType.None.rawValue,"0", "0"],
         ["36",  "Cargo Lift Lobby", NodeType.None.rawValue,"0", "1"],
         ["37",  "Car Park", NodeType.Facility.rawValue,"0", "1"],
         ["38",  "Car Entrance", NodeType.Facility.rawValue,"0", "1"],
         ["39",  "ERB 4F Entrance", NodeType.Facility.rawValue,"0", "1"]]
    
    static let storeTypeImage = [UIImage(named:"Default"), UIImage(named:"Restaurant"), UIImage(named:"Clothing"), UIImage(named:"Facility"), UIImage(named:"Default")]
    static let filterType = ["All", "Restaurant", "Clothing", "Facility", "None"]
    
    static let floorPlanImage = [UIImage(named:"floorPlanGF"), UIImage(named:"floorPlanF5"), UIImage(named:"floorPlanF9")]
    static let floorPlanIndex = [0,5,9]
    
    
    

    static let findSeatBeaconCoordinate = [[0.0, u/2], [v/2,0.0], [v,u/2], [v/2,u]]
    
    
    static let findSeatFloorPlanUnit = [14.0, 70] //x , y
    static let findSeatUnitSize = 0.254 // in meter ~ 25.4cm = 10 inch
    static let findSeatStartPoint = [5.0,69.0]
    static let findSeatFloorPlanImage = UIImage(named:"F9Terrace")
    
    static let widthUnit : Double = Double(findSeatFloorPlanImage!.size.width) / Constants.findSeatUnitSize / Constants.findSeatFloorPlanUnit[0]
    static let heightUnit : Double = Double(findSeatFloorPlanImage!.size.height) / Constants.findSeatUnitSize / Constants.findSeatFloorPlanUnit[1]
    
//    struct VU_Distance {
//        var u: Double = 0.0
//        var v: Double = 0.0
//        init(_ u: Double, _ v: Double) {
//            self.v = v
//            self.u = u
//        }
//    }
}
