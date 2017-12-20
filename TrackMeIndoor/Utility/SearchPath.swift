//
//  FloorPlanCoordinates.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation


class SearchPath{

    
    struct nodeInfoOnEachFloor {
        static let nodeRange = [[15, 32], [1,14]]
        static let floorName = [5,9]
        static let floorChangedNodes = [[15,32], [12,14]]
    }
    
    // ID + nodeName
    static let nodeName =
    [["1",  "Rm 924B Entrance"],
     ["2",  "Terrace Right Entrance"],
     ["3",  "Rm 924A Entrance"],
     ["4",  "Rm 922 Entrance"],
     ["5",  "Rm 921 Entrance"],
     ["6",  "Terrace Left Entrance"],
     ["7",  "Toilet"],
     ["8",  "Rm 904 Entrance"],
     ["9",  "Rm 913 Left Entrance"],
     ["10", "Rm 901 Entrance"],
     ["11", "Rm 913 Right Entrance"],
     ["12", "F9 Lift Lobby"],
     ["13", "Corridor"],
     ["14", "F9 Cargo Lift Lobby"],
     ["15",  "F5 Lift Lobby"],
     ["16",  "Corridor"],
     ["17",  "Rm 503 Entrance"],
     ["18",  "Rm 504 Entrance"],
     ["19",  "Rm 505 Entrance"],
     ["20",  "Covered Terrace Entrance"],
     ["21",  "Covered Treace"],
     ["22",  "Covered Terrace Entrance"],
     ["23",  "Foyer"],
     ["24",  "Foyer Entrance"],
     ["25",  "Corner"],
     ["26",  "Stair Entrance"],
     ["27",  "Foyer to Rm 508"],
     ["28",  "Rm 508 Inner Left Entrance"],
     ["29",  "Rm 508"],
     ["30",  "Rm 508 Inner Right Entrance"],
     ["31",  "Foyer to Rm 508"],
     ["32", "F5 Cargo Lift Lobby"],
    ]
    
    
    
//    static let coordinates = [[263,271],
//                              [263,227],
//                              [263,188],
//                              [263,243],
//                              [126,259],
//                              [126,227],
//                              [126,244],
//                              [126,170],
//                              [126,128],
//                              [126,198],
//                              [263,128],
//                              [126,271],
//                              ]
    
    static let coordinates = [[536, 552], [536, 464], [536, 386], [536, 496], [260, 528], [260, 464], [260, 498], [260, 350], [260, 266], [260, 406], [536, 266], [260, 552], [398, 552], [536, 602],
                              [278, 456], [423, 456], [571, 456], [571, 359], [571, 290], [278, 393], [278, 296], [278, 146], [423, 146], [535, 146], [535, 185], [571, 185],
                              [341, 146], [341, 230], [423, 230], [505, 230], [505, 146], [571,526]]
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
    
//    static let connects = [[1,4,28],
//                           [1,12,137],
//                            [2,3,39] ,
//                            [2,4,16],
//                            [2,6,137],
//                            [3,2,39],
//                            [3,11,60],
//                            [4,1,28],
//                            [4,2,16],
//                            [5,7,15],
//                            [5,12,12],
//                            [6,2,137],
//                            [6,7,17],
//                            [6,10,29],
//                            [7,5,15],
//                            [7,6,17],
//                            [8,9,42],
//                            [8,10,28],
//                            [9,8,42],
//                            [10,6,29],
//                            [10,8,28],
//                            [11,3,60],
//                            [12,1,137],
//                            [12,5,12]]
//   static let connects = [[1, 4, 56], [1, 13, 137],
//                          [2, 3, 78], [2, 4, 32], [2, 6, 274],
//                          [3, 2, 78], [3, 11, 120],
//                          [4, 1, 56], [4, 2, 32],
//                          [5, 7, 30], [5, 12, 24],
//                          [6, 2, 274], [6, 7, 34], [6, 10, 58],
//                          [7, 5, 30], [7, 6, 34],
//                          [8, 9, 84], [8, 10, 56],
//                          [9, 8, 84], [10, 6, 58],
//                          [10, 8, 56], [11, 3, 120],
//                          [12, 13, 137], [12, 5, 24],[12, 14, 200],
//                          [13, 1, 137], [13, 12, 137],
//                            [14, 12, 200],
//                            [14, 15, 148], [14, 19, 63],
//                            [15, 14, 148], [15, 16, 145],
//                            [16, 15, 145], [16, 17, 97],
//                            [17,16, 97], [17, 18, 69],
//                            [18, 17, 69], [18, 25, 105],
//                            [19, 14, 63], [19, 20, 97],
//                            [20, 19, 97], [20, 21, 150],
//                            [21, 20, 150], [21, 26, 63],
//                            [22, 21, 145], [22, 30, 82],
//                            [23, 22, 112], [23, 24, 39],
//                            [24,23, 39], [24, 25, 36],
//                            [25, 18, 105], [25, 24, 36],
//                            [26, 21, 63], [26, 22, 82], [26, 27, 84],
//                            [27, 26, 84], [27, 28, 82],
//                            [28, 27, 82], [28, 29, 82],
//                            [29, 28, 82], [29, 30, 84],
//                            [30, 22, 82], [30, 29, 84], [30, 23, 30]]
    static let connects = [[1, 4, 57], [1, 13, 138],[1, 14, 50],
                           [2, 3, 79], [2, 4, 33], [2, 6, 275],
                           [3, 2, 79], [3, 11, 121],
                           [4 , 1, 57], [4, 2, 33],
                           [5, 7, 31], [5, 12, 25],
                           [6, 2, 275], [6, 7, 35], [6, 10,59],
                           [7, 5, 31], [7, 6, 35],
                           [8, 9, 85], [8, 10, 57],
                           [9, 8, 85], [10, 6, 59],
                           [10, 8, 57], [11, 3, 121],
                           [12, 13, 138], [12, 5, 25],[12, 15, 201],
                           [13, 1, 138], [13, 12, 138],
                           [14, 1, 50], [14, 32, 200],
                           [15, 12, 201], [15, 16, 149], [15, 20, 64],
                           [16, 15, 149], [16 , 17, 146],
                           [17, 16, 146], [17, 18, 98],
                           [18, 17, 98], [18, 19, 70],
                           [19, 18, 70], [19, 26, 106],
                           [20, 15, 64], [20, 21, 98],
                           [21, 20, 98], [21, 22, 151],
                           [22,21, 151], [22, 27, 64],
                           [23, 22, 146], [23, 31, 83],
                           [24, 23, 113], [24, 25, 40],
                           [25, 24, 40], [25, 26, 37],
                           [26, 19, 106], [26, 25, 37],
                           [27, 22, 64], [27, 23, 83],[27, 28, 85],
                           [28, 27, 85], [28, 29, 83],
                           [29, 28, 83], [29, 30, 83],
                           [30, 29, 83], [30, 31, 85],
                           [31, 23, 83], [31, 30, 85], [31, 24, 31],
                           [32, 14, 200], [32, 17, 70]]


    static var minPath = [Int]()
    static func search (currentLoctionNodeID: Int, destinationNodeID: Int, searchedPath: [Int], costSoFar: Int, minCostSoFar: Int) -> (Int, [Int]){
        let nodes = connects.filter({$0[0] == currentLoctionNodeID})
        var minCostSoFarV = minCostSoFar
        
        
       // print("Begin: searchedPath \(searchedPath) costSoFar: \(costSoFar) minCost:\(minCostSoFar)")
        for node in nodes{
            let costSoFarV = costSoFar + node[2]
            if costSoFarV < minCostSoFarV || minCostSoFarV < 0{
                var searchedPathV = searchedPath
                if searchedPath.contains(node[1]){
                    continue // Avoid re-loop
                }
                
                searchedPathV.append(node[1])
                if destinationNodeID == node[1]{
                    return (costSoFarV, searchedPathV) // Base case
                }
                let (minCost, tempPath ) = search(currentLoctionNodeID: node[1], destinationNodeID: destinationNodeID,
                                                        searchedPath: searchedPathV, costSoFar: costSoFarV, minCostSoFar: minCostSoFarV)
                
                if (minCost < minCostSoFarV ){
                    minCostSoFarV = minCost
                    minPath = tempPath
                    //print("2: cost \(cost), minCost \(minCost) minCostSoFar \(minCostSoFarV) minPath:\(minPath) searched \(searchedPathV)")
                }else if (minCost > 0 ){
                    minCostSoFarV = minCost
                    minPath = tempPath
                    //print("1: cost \(cost), minCost \(minCost) minCostSoFar \(minCostSoFarV) minPath:\(minPath) searched \(searchedPathV)")
                }
                
            }
        }
        //print("3: minCostSoFar \(minCostSoFarV)  minPath \(minPath) nodes:\(nodes)")
        return (minCostSoFarV, minPath)
    }
    

   
}
