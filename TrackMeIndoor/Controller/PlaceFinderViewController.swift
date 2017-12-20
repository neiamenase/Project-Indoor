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
    @IBOutlet weak var pathDetailsLabel: UILabel!
    
    var floorPlan : UIImage = UIImage(named: "floorPlanF9")!
    
    var currentLocationNodeID = -1
    var destinationNodeID = -1
    var locationManager = CLLocationManager()
    var items = [Item]()
    var path = [Int]()
    var timeCost = 0
    
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
            
            imageView.image = DrawImage().drawFloorPlanPathLocation(startingImage: floorPlan, path: path)
            
            pathDetailsLabel.text = ""
            
            var terraceEnterFlag : Int = 0
            let actionWord = ["Enter", "Leave"]
            for i in 1..<path.count-1{
                if path.contains(2) && path.contains(6){
                    if path[i] == 2 || path[i] == 6 {
                        pathDetailsLabel.text = pathDetailsLabel.text! + "\t\(i). \(actionWord[terraceEnterFlag]) Terrace\n"
                        terraceEnterFlag += 1
                    }else{
                        pathDetailsLabel.text = pathDetailsLabel.text! + "\t\(i). Pass through \(SearchPath.nodeName[path[i]-1][1])\n"
                    }
                }else{
                    pathDetailsLabel.text = pathDetailsLabel.text! + "\t\(i). Pass through \(SearchPath.nodeName[path[i]-1][1])\n"
                }
                
            }
            pathDetailsLabel.text = pathDetailsLabel.text! + "\t\(path.count-1). Arrival \(SearchPath.nodeName[path.last!-1][1])\n"
        }
        

        
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
