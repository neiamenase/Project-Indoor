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
        static let nodeRange = [[33, 39], [15, 32], [1,14]]
        static let floorName = [5,9]
        static let floorChangedNodes = [[33, 36],[15,32], [12,14]]
    }
    
    // ID + nodeName
    static let nodeName =
    [["1",  "Rm 924B Entrance", "Restaurant"],
     ["2",  "Terrace Right Entrance", "Facility"],
     ["3",  "Rm 924A Entrance", "Restaurant"],
     ["4",  "Rm 922 Entrance", "Clothing"],
     ["5",  "Rm 921 Entrance", "Clothing"],
     ["6",  "Terrace Left Entrance", "Facility"],
     ["7",  "Toilet", "Facility"],
     ["8",  "Rm 904 Entrance", "Clothing"],
     ["9",  "Rm 913 Left Entrance", "Restaurant"],
     ["10", "Rm 901 Entrance", "Clothing"],
     ["11", "Rm 913 Right Entrance", "Restaurant"],
     ["12", "F9 Lift Lobby", "Facility"],
     ["13", "Corridor", "Facility"],
     ["14", "F9 Cargo Lift Lobby", "Facility"],
     ["15",  "F5 Lift Lobby", "Facility"],
     ["16",  "Corridor", "Facility"],
     ["17",  "Rm 503 Entrance", "Restaurant"],
     ["18",  "Rm 504 Entrance", "Restaurant"],
     ["19",  "Rm 505 Entrance", "Restaurant"],
     ["20",  "Covered Terrace Entrance", "Facility"],
     ["21",  "Covered Treace", "Facility"],
     ["22",  "Covered Terrace Entrance", "Facility"],
     ["23",  "Foyer", "Facility"],
     ["24",  "Foyer Entrance", "Facility"],
     ["25",  "Corner", "Facility"],
     ["26",  "Stair Entrance", "Facility"],
     ["27",  "Foyer to Rm 508", "Facility"],
     ["28",  "Rm 508 Inner Left Entrance", "Restaurant"],
     ["29",  "Rm 508", "Restaurant"],
     ["30",  "Rm 508 Inner Right Entrance", "Restaurant"],
     ["31",  "Foyer to Rm 508", "Facility"],
     ["32",  "F5 Cargo Lift Lobby", "Facility"],
     ["33",  "GF Lift Lobby", "Facility"],
     ["34",  "GF Entrance Lobby", "Facility"],
     ["35",  "Cargo Lift Lobby Entrance", "Facility"],
     ["36",  "Cargo Lift Lobby", "Facility"],
     ["37",  "Car Park", "Facility"],
     ["38",  "Car Entrance", "Facility"],
     ["39",  "ERB 4F Entrance", "Facility"]]
    
    static let coordinates = [[536, 552], [536, 464], [536, 386], [536, 496], [260, 528], [260, 464], [260, 498], [260, 350], [260, 266], [260, 406], [536, 266], [260, 552], [398, 552], [536, 602],
                              [278, 456], [423, 456], [571, 456], [571, 359], [571, 290], [278, 393], [278, 296], [278, 146], [423, 146], [535, 146], [535, 185], [571, 185],
                              [341, 146], [341, 230], [423, 230], [505, 230], [505, 146], [571,526],
                              [288, 470], [407, 470], [522, 470], [522, 510], [407, 369], [193, 369], [193,55]]
    //Connect - Relations
    
    // from node, to node, time cost
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
                           [12, 13, 138], [12, 5, 25], [12, 15, 250],[12, 33, 400],
                           [13, 1, 138], [13, 12, 138],
                           [14, 1, 50], [14, 32, 200], [14, 36, 400],
                           [15, 12, 250], [15, 16, 149], [15, 20, 64], [15, 33, 250],
                           [16, 15, 149], [16 , 17, 146],
                           [17, 16, 146], [17, 18, 98],
                           [18, 17, 98], [18, 19, 70],
                           [19, 18, 70], [19, 26, 106],
                           [20, 15, 64], [20, 21, 98],
                           [21, 20, 98], [21, 22, 151],
                           [22, 21, 151], [22, 27, 64],
                           [23, 22, 146], [23, 31, 83],
                           [24, 23, 113], [24, 25, 40],
                           [25, 24, 40], [25, 26, 37],
                           [26, 19, 106], [26, 25, 37],
                           [27, 22, 64], [27, 23, 83],[27, 28, 85],
                           [28, 27, 85], [28, 29, 83],
                           [29, 28, 83], [29, 30, 83],
                           [30, 29, 83], [30, 31, 85],
                           [31, 23, 83], [31, 30, 85], [31, 24, 31],
                           [32, 14, 250], [32, 17, 70], [32, 36, 400],
                           [33, 12, 400], [33, 15, 250], [33, 34, 119],
                           [34, 33, 119], [34, 35, 115], [34, 37, 101],
                           [35, 34, 115], [35, 36, 40],
                           [36, 14, 400], [36, 32, 250], [36,35,40],
                           [37, 34, 101], [37, 38, 214],
                           [38, 37, 214], [38, 39, 314],
                           [39, 38, 314]]


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
