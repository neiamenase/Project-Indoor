//
//  FloorPlanCoordinates.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation


class SearchPath{

    
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
     ["12", "Corridor"]]
    
    
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
    
    static let coordinates = [[536, 552], [536, 464], [536, 386], [536, 496], [260, 528], [260, 464], [260, 498], [260, 350], [260, 266], [260, 406], [536, 266], [260, 552]]
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
   static let connects = [[1, 4, 56], [1, 12, 274],
                          [2, 3, 78], [2, 4, 32], [2, 6, 274],
                          [3, 2, 78], [3, 11, 120],
                          [4, 1, 56], [4, 2, 32],
                          [5, 7, 30], [5, 12, 24],
                          [6, 2, 274], [6, 7, 34], [6, 10, 58],
                          [7, 5, 30], [7, 6, 34],
                          [8, 9, 84], [8, 10, 56],
                          [9, 8, 84], [10, 6, 58],
                          [10, 8, 56], [11, 3, 120],
                          [12, 1, 274], [12, 5, 24]]

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
