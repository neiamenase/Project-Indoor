//
//  Store.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 23/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation
import UIKit

class Store {
    var name : String
    var image : UIImage?
    var nodeID : Int
    var coordinates : Coordinates
    var distance : Int
    
    init?(name: String, image: UIImage?, nodeID: Int, coordinates: Coordinates, distance: Int) {
        if name.isEmpty  {
            return nil
        }
        self.name = name
        self.image = image
        self.nodeID = nodeID
        self.coordinates = coordinates
        self.distance = distance
    }
    
    
}
