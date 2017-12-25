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
        static let floorName = [0,5,9]
        static let floorChangedNodes = [[33, 36],[15,32], [12,14]]
    }
    
    static let liftNodes = [33,36,15,32,12,14]
    
    
    static let coordinates = [[536, 552], [536, 464], [536, 386], [536, 496], [260, 528], [260, 464], [260, 498], [260, 350], [260, 266], [260, 406], [536, 266], [260, 552], [398, 552], [536, 602],
                              [278, 456], [423, 456], [571, 456], [571, 359], [571, 290], [278, 393], [278, 296], [278, 146], [423, 146], [535, 146], [535, 185], [571, 185],
                              [341, 146], [341, 230], [423, 230], [505, 230], [505, 146], [571,526],
                              [288, 470], [407, 470], [522, 470], [522, 510], [407, 369], [193, 369], [193,55]]
    //Connect - Relations
    
    // from node, to node, time cost
    static let connects = [[1, 4, 56], [1, 13, 138], [1, 14, 50],
                           [2, 3, 78], [2, 4, 32], [2, 6, 276],
                           [3, 2, 78], [3, 11, 120],
                           [4, 1, 56], [4, 2, 32],
                           [5, 7, 30], [5, 12, 24],
                           [6, 2, 276], [6, 7, 34], [6, 10, 58],
                           [7, 5, 30], [7, 6, 34],
                           [8, 9, 84], [8, 10, 56],
                           [9, 8, 84],
                           [10, 6, 58], [10, 8, 56],
                           [11, 3, 120],
                           [12, 13, 138], [12, 5, 24], [12, 15, 250], [12, 33, 400],
                           [13, 1, 138], [13, 12, 138],
                           [14, 1, 50], [14, 32, 250], [14, 36, 400],
                           [15, 12, 250], [15, 16, 145], [15, 20, 63], [15, 33, 400],
                           [16, 15, 145], [16, 17, 148],
                           [17, 16, 148], [17, 18, 97],
                           [18, 17, 97], [18, 19, 69],
                           [19, 18, 69], [19, 26, 105],
                           [20, 15, 63], [20, 21, 97],
                           [21, 20, 97], [21, 22, 150],
                           [22, 21, 150], [22, 27, 63],
                           [23, 27, 82], [23, 31, 82],
                           [24, 31,30], [24, 25, 39],
                           [25, 24, 39], [25, 26, 36],
                           [26, 19, 105], [26, 25, 36],
                           [27, 22, 63], [27, 23, 82], [27, 28, 84],
                           [28, 27, 84], [28, 29, 82],
                           [29, 28, 82], [29, 30, 82],
                           [30, 29, 82], [30, 31, 84],
                           [31, 23, 82], [31, 30, 84], [31,24, 30],
                           [32, 14, 250], [32, 17, 70], [32, 36, 400],
                           [33, 12, 400], [33, 15, 250], [33, 34, 119],
                           [34, 33, 119], [34, 35, 115], [34, 37, 101],
                           [35, 34, 115], [35, 36, 40],
                           [36, 14, 250], [36, 32, 400], [36, 35, 40],
                           [37, 34, 101], [37, 38 , 214],
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
        //print("3: minCostSoFar3 \(minCostSoFarV)  minPath \(minPath) nodes:\(nodes)")
        return (minCostSoFarV, minPath)
    }
    static var totalCount = 0;
    
    static func SearchPathByNodeType(type: Constants.NodeType ,currentLoctionNodeID: Int)-> (Int, Int, [Int]){
        if type == Constants.NodeType.None{
            return (0, 0, [])
        }
        self.totalCount = Constants.storesDB.filter({$0[2] == type.rawValue}).count
        bestResult = searchResult();
        searchPathByType(type: type, currentCount: 0, currentLoctionNodeID: currentLoctionNodeID,
                         searchedPath: [currentLoctionNodeID], costSoFar: 0, revisitLift: 2)
        return (bestResult.cost, bestResult.nodeMatched, bestResult.path)
    }
    
    struct searchResult{
        var cost : Int
        var nodeMatched : Int
        var path: [Int]
        init() {
            self.nodeMatched = 0
            self.cost = -1
            self.path = []
        }
    }
    
    static var bestResult = searchResult(); // consider: getAllPoints,
    
    private static func searchPathByType (type: Constants.NodeType, currentCount: Int, currentLoctionNodeID: Int, searchedPath: [Int], costSoFar: Int, revisitLift: Int)-> Void{
        let subNodes = connects.filter({$0[0] == currentLoctionNodeID})
        for subNode in subNodes{
            var currentCountV = currentCount
            var searchedPathV = searchedPath
            var revisitLiftV = revisitLift
            let subNodeDetails = Constants.storesDB.filter({Int($0[0]) == currentLoctionNodeID}).first!
            let costSoFarV = costSoFar + subNode[2]
            
            if searchedPath.contains(subNode[1]){
                if liftNodes.contains(subNode[1]) && revisitLiftV > 0{
                    revisitLiftV = revisitLiftV - 1
                }else{
                    continue // Avoid re-loop
                }
            }
            searchedPathV.append(subNode[1])
            if subNodeDetails[2] == type.rawValue {
                currentCountV = currentCountV + 1
                if bestResult.cost == -1 || currentCountV > bestResult.nodeMatched || (currentCountV == bestResult.nodeMatched && costSoFarV < bestResult.cost) {
                    // replace the best Result by current result
                    bestResult.cost = costSoFarV
                    bestResult.nodeMatched = currentCountV
                    bestResult.path = searchedPathV
                }
            }
            searchPathByType(type: type, currentCount: currentCountV, currentLoctionNodeID: subNode[1],
                             searchedPath: searchedPathV, costSoFar: costSoFarV, revisitLift: revisitLiftV)
        }
    }
}
