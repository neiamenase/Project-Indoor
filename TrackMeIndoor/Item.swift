//
//  Item.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 17/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation
import CoreLocation
struct ItemConstant {
    static let nameKey = "name"
    static let iconKey = "icon"
    static let uuidKey = "uuid"
    static let majorKey = "major"
    static let minorKey = "minor"
}

class Item: NSObject, NSCoding {
    let name: String
    let icon: Int
    let uuid: UUID
    let majorValue: UInt16
    let minorValue: UInt16
    let distance: Double
    var beacon: CLBeacon?
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid,
                              major: majorValue,
                              minor: minorValue,
                              identifier: name)
    }
    init(name: String, icon: Int, uuid: UUID, majorValue: Int, minorValue: Int, distance: Double) {
        self.name = name
        self.icon = icon
        self.uuid = uuid
        self.majorValue = UInt16(majorValue)
        self.minorValue = UInt16(minorValue)
        self.distance = distance
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "Location: \(proximity)"
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        
        return location
    }
    
    
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: ItemConstant.nameKey) as? String
        name = aName ?? ""
        
        let aUUID = aDecoder.decodeObject(forKey: ItemConstant.uuidKey) as? UUID
        uuid = aUUID ?? UUID()
        
        icon = aDecoder.decodeInteger(forKey: ItemConstant.iconKey)
        majorValue = UInt16(aDecoder.decodeInteger(forKey: ItemConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeInteger(forKey: ItemConstant.minorKey))
        distance = 0.0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: ItemConstant.nameKey)
        aCoder.encode(icon, forKey: ItemConstant.iconKey)
        aCoder.encode(uuid, forKey: ItemConstant.uuidKey)
        aCoder.encode(Int(majorValue), forKey: ItemConstant.majorKey)
        aCoder.encode(Int(minorValue), forKey: ItemConstant.minorKey)
    }
    
}


func ==(item: Item, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}
