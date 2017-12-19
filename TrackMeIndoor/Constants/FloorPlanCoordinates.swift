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
    
    
    static let coordinates = [[263,271],
                              [263,227],
                              [263,188],
                              [263,243],
                              [126,259],
                              [126,227],
                              [126,244],
                              [126,170],
                              [126,128],
                              [126,198],
                              [263,128],
                              [126,271],
                              ]
    //Connect - Relations
    
    // from node, to node, time cost
//    var connects = [[1,4,0],[1,12,0],
//                   [2,3,0],[2,4,0],[2,6,0],
//                   [3,2,0],[3,11,0],
//                   [4,1,0],[4,2,0],
//                   [5,7,0],[5,12,0],
//                   [6,2,0],[6,7,0],[6,10,0],
//                   [7,5,0],[7,6,0],
//                   [8,9,0],[8,10,0],
//                   [9,8,0],
//                   [10,6,0],[10,8,0],
//                   [11,3,0],[12,1,0],
//                   [12,5,0]]
    
    static let connects = [[1,4,28],[1,12,137],
                            [2,3,39],[2,4,16],[2,6,137],
                            [3,2,39],[3,11,60],
                            [4,1,28],[4,2,16],
                            [5,7,15],[5,12,12],
                            [6,2,137],[6,7,17],[6,10,29],
                            [7,5,15],[7,6,17],
                            [8,9,42],[8,10,28],
                            [9,8,42],
                            [10,6,29],[10,8,28],
                            [11,3,60],
                            [12,1,137],[12,5,12]]
    
    init(){
        
    }
   

   
}
