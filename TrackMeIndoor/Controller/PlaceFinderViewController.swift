//
//  PlaceFinderViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceFinderViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoMessageLabel: UILabel!
    @IBOutlet weak var pathDescriptionTextView: UITextView!
    @IBOutlet weak var floorSegmentedControl: UISegmentedControl!
    

    var floorPlan :[UIImage] = [UIImage(named: "floorPlanGF")!,UIImage(named: "floorPlanF5")!, UIImage(named: "floorPlanF9")!]
    var currentLocationNodeID = -1
    var destinationNodeID = -1
    var locationManager = CLLocationManager()
    var items = [Item]()
    var path = [Int]()
    var timeCost = 0
    var startFloor = 0
    var endFloor = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // locationManager.delegate = self
        

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        infoMessageLabel.text = "curr:\(currentLocationNodeID) dest:\(destinationNodeID)"
        

        (timeCost, path ) = SearchPath.search(currentLoctionNodeID: currentLocationNodeID, destinationNodeID: destinationNodeID,
                                            searchedPath: [currentLocationNodeID], costSoFar: 0, minCostSoFar: -1)
        
        if !path.isEmpty {
            print ("Finish -- time: \(timeCost) path:\(path)\n\n")

            for i in 0..<SearchPath.nodeInfoOnEachFloor.nodeRange.count{
                if path[0] >= SearchPath.nodeInfoOnEachFloor.nodeRange[i][0] && path[0] <= SearchPath.nodeInfoOnEachFloor.nodeRange[i][1]{
                    startFloor = i
                    floorSegmentedControl.selectedSegmentIndex = i
                }
                if path[path.count-1] >= SearchPath.nodeInfoOnEachFloor.nodeRange[i][0] && path[path.count-1] <= SearchPath.nodeInfoOnEachFloor.nodeRange[i][1]{
                    endFloor = i
                }
            }
            
            if startFloor != endFloor{
                for liftNum in 0..<SearchPath.nodeInfoOnEachFloor.floorChangedNodes[0].count{
                    let liftStartNode = path.index(of: SearchPath.nodeInfoOnEachFloor.floorChangedNodes[startFloor][liftNum])
                    let liftEndNode = path.index(of: SearchPath.nodeInfoOnEachFloor.floorChangedNodes[endFloor][liftNum])
                    if liftStartNode != nil && liftEndNode != nil{
                        if liftStartNode == liftEndNode! - 1{
                            let firstPath = Array(path[0..<liftEndNode!])
                            drawPath(floor: startFloor, path: firstPath)
                            let secondPath = Array(path[liftEndNode!...])
                            drawPath(floor: endFloor, path: secondPath)
                            break
                        }
                    }
                }
//                let changeFloorAtIndex = path.index(of: SearchPath.nodeInfoOnEachFloor.nodeRange[endFloor][0])!
                
            }else{
                drawPath(floor: startFloor, path: path)
            }
            pathDescription()
            imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
            
            
        }
//        for a in 32..<SearchPath.coordinates.count{
//            print(SearchPath.coordinates[a])
//        floorPlan[0] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[0], x: SearchPath.coordinates[a][0], y: SearchPath.coordinates[a][1], color: UIColor.red.cgColor)
//        }
//        imageView.image = floorPlan[0]
    }
    func drawPath(floor: Int, path: [Int]) -> Void{
        floorPlan[floor] = DrawImage().drawFloorPlanPathLocation(startingImage: floorPlan[floor], path: path)

    }
    
    func pathDescription() -> Void{
        pathDescriptionTextView.text = ""
        
        var terraceEnterFlag : Int = 0
        let actionWord = ["Enter", "Leave"]
        for i in 1..<path.count-1{
            if path.contains(2) && path.contains(6){
                if path[i] == 2 || path[i] == 6 {
                    pathDescriptionTextView.text = pathDescriptionTextView.text! + "\t\(i). \(actionWord[terraceEnterFlag]) Terrace\n"
                    terraceEnterFlag += 1
                }else{
                    pathDescriptionTextView.text = pathDescriptionTextView.text! + "\t\(i). Pass through \(SearchPath.nodeName[path[i]-1][1])\n"
                }
            }else{
                pathDescriptionTextView.text = pathDescriptionTextView.text! + "\t\(i). Pass through \(SearchPath.nodeName[path[i]-1][1])\n"
            }
            
        }
        pathDescriptionTextView.text = pathDescriptionTextView.text! + "\t\(path.count-1). Arrival \(SearchPath.nodeName[path.last!-1][1])\n"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewForZooming(in scrollview: UIScrollView) -> UIView? {
        return self.imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func floorChanged(_ sender: UISegmentedControl) {
        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
        
    }
    
}
//
//extension PlaceFinderViewController: CLLocationManagerDelegate{
//
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        print("Failed monitoring region: \(error.localizedDescription)")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed: \(error.localizedDescription)")
//    }
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//
//
//        // Find the same beacons in the table.
//
//        for beacon in beacons {
//            for row in 0..<items.count {
//                // TODO: Determine if item is equal to ranged beacon
//                if items[row] == beacon {
//                    items[row].beacon = beacon
//                }
//            }
//        }
//        for item in items {
//            switch item.beacon?.proximity{
//            case .immediate?:
//                let i = Constants.beaconsInfo.name.index(of: item.name)
//                if Constants.beaconsInfo.nodeID[i!] == destinationNodeID{
//                    infoMessageLabel.text = "Arrivaled \(Constants.beaconsInfo.nodeDescription[i!])"
//                }else if Constants.beaconsInfo.nodeID[i!] == currentLocationNodeID{
//                    continue
//                }
//                else if path.contains(Constants.beaconsInfo.nodeID[i!]) {
//                    infoMessageLabel.text = "You are in \(Constants.beaconsInfo.nodeDescription[i!])"
//                }else {
//                    infoMessageLabel.text = "Wrong Direction! "
//                }
//            default: break
//            }
//        }
//    }
//}
//
