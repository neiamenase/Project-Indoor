//
//  FloorPlanCoordinates.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation


class FloorPlanCoordinates{

    
    // ID + nodeName
    static let nodeName =
    [["1", "924B_Down_Entrance"],
     ["2", "Central_right"],
     ["3", "924A_Up_Entrance"],
     ["4", "922_Entrance"],
     ["5", "921_Entrance"],
     ["6", "Central_Left"],
     ["7", "Toilet"],
     ["8", "904_Entrance"],
     ["9", "913_left_Entrance"],
     ["10", "901_Entrance"],
     ["11", "913_right_Entrance"],
     ["12", "Corridor"]]
    
    

    //Connect - Relations
    
    // from node, to node, time cost
    var connect = [[1,4,0],[1,12,0],
                   [2,3,0],[2,4,0],[2,6,0],
                   [3,2,0],[3,11,0],
                   [4,1,0],[4,2,0],
                   [5,7,0],[5,12,0],
                   [6,2,0],[6,7,0],[6,10,0],
                   [7,5,0],[7,6,0],
                   [8,9,0],[8,10,0],
                   [9,8,0],
                   [10,6,0],[10,8,0],
                   [11,3,0],[12,1,0],
                   [12,5,0]]

   
}
