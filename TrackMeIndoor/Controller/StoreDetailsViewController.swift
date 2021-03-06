//
//  StoreDetailsViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 24/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class StoreDetailsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storeDetailsTextView: UITextView!
    @IBOutlet weak var pathDetailsTextView: UITextView!
    @IBOutlet weak var floorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var goButton: UIButton!
    
 
    var store : Store? = nil
    
    var floorPlan = Constants.floorPlanImage
    var floorPlanWithCurrent = Constants.floorPlanImage
    var currentLocationNodeID = -1
    var lastCurrentLocationNodeID = -1
    var destinationNodeID = -1
    var pathPlanned = false
    
    var items = [Item]()
    var path = [Int]()
    var timeCost = 0
    var startFloor = 0
    var endFloor = 0
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        loadStoreInfo()
        locationManager.delegate = self
        loadItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadStoreInfo (){
        self.title = store?.name
        currentLocationLabel.text = "Current Location: Searching..."
        destinationNodeID = (store?.nodeID)!
        floorSegmentedControl.selectedSegmentIndex = Constants.floorPlanIndex.index(of:(store?.floor)!)!

        floorPlan[floorSegmentedControl.selectedSegmentIndex]! = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[floorSegmentedControl.selectedSegmentIndex]!, x: SearchPath.coordinates[(store?.nodeID)!-1][0], y: SearchPath.coordinates[(store?.nodeID)!-1][1], color: UIColor.red.cgColor)
        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]!
        floorPlanWithCurrent = floorPlan
        storeDetailsTextView.text = "Category: \n\((store?.category)!)\n\nFloor: \n\((store?.floor)!)\n\nShop:\n\((store?.name)!)"
    }
    
    @IBAction func planPath(_ sender: Any) {
        floorPlan = Constants.floorPlanImage
        if currentLocationNodeID == -1{
            let alert = UIAlertController(title: "Current Location Not Found", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            currentLocationNodeID = 39
            lastCurrentLocationNodeID = currentLocationNodeID
        }
//            return
//        }else{
            (timeCost, path ) = SearchPath.search(currentLoctionNodeID: currentLocationNodeID, destinationNodeID: destinationNodeID,
                                                  searchedPath: [currentLocationNodeID], costSoFar: 0, minCostSoFar: -1)
            
//        }
        if !path.isEmpty {
            pathPlanned = true
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
                
            }else{
                drawPath(floor: startFloor, path: path)
            }
            
            floorPlan[startFloor] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[startFloor]!, x: SearchPath.coordinates[path[0]-1][0], y: SearchPath.coordinates[path[0]-1][1], color: UIColor.green.cgColor)
            floorPlan[endFloor] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[endFloor]!, x: SearchPath.coordinates[path[path.count-1]-1][0], y: SearchPath.coordinates[path[path.count-1]-1][1], color: UIColor.red.cgColor)
            
            pathDescription()
            imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
            floorPlanWithCurrent = floorPlan
            if items.isEmpty{
                loadItems()
                
            }
            
        }
        
    }
    func drawPath(floor: Int, path: [Int]) -> Void{
        floorPlan[floor] = DrawImage().drawFloorPlanPathLocation(startingImage: floorPlan[floor]!, path: path)
        
        
        
    }
    func pathDescription() -> Void{
        pathDetailsTextView.text = ""
        
        var terraceEnterFlag : Int = 0
        let actionWord = ["Enter", "Leave"]
        for i in 1..<path.count-1{
            if path.contains(2) && path.contains(6){
                if path[i] == 2 || path[i] == 6 {
                    pathDetailsTextView.text = pathDetailsTextView.text! + "\(i). \(actionWord[terraceEnterFlag]) Terrace\n"
                    terraceEnterFlag += 1
                }else{
                    pathDetailsTextView.text = pathDetailsTextView.text! + "\(i). Pass through \(Constants.storesDB[path[i]-1][1])\n"
                }
            }else{
                pathDetailsTextView.text = pathDetailsTextView.text! + "\(i). Pass through \(Constants.storesDB[path[i]-1][1])\n"
            }
            
        }
        pathDetailsTextView.text = pathDetailsTextView.text! + "\(path.count-1). Arrival \(Constants.storesDB[path.last!-1][1])\n"
    }
    
    func drawCurrentLocation() -> Void {
        floorSegmentedControl.selectedSegmentIndex = Constants.floorPlanIndex.index(of: Int(Constants.storesDB[currentLocationNodeID-1][3])!)!
        floorPlanWithCurrent = floorPlan
        floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[floorSegmentedControl.selectedSegmentIndex]!, x: SearchPath.coordinates[currentLocationNodeID-1][0], y: SearchPath.coordinates[currentLocationNodeID-1][1], color: UIColor.blue.cgColor)
        imageView.image = floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex]
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
        imageView.image = floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex]
        
    }
    func viewForZooming(in scrollview: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // Moitoring iBeacon
    func stopMonitoringItem(_ item: Item) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    
    func startMonitoringItem(_ item: Item) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func loadItems() {
        for i in 0..<Constants.beaconsInfo.name.count{
            items.append(Item(name: Constants.beaconsInfo.name[i], icon: 0, uuid: Constants.uuid, majorValue: Constants.iBeaconMajor, minorValue: Constants.beaconsInfo.minor[i], distance: 0.0))
        }
        for item in items{
            startMonitoringItem(item)
        }
    }
}
extension StoreDetailsViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        
        // Find the same beacons in the table.
        
        for beacon in beacons {
            for row in 0..<items.count {
                // TODO: Determine if item is equal to ranged beacon
                if items[row] == beacon {
                    items[row].beacon = beacon
                }
            }
        }
        for item in items {
            switch item.beacon?.proximity{
            case .immediate?:
                let i = Constants.beaconsInfo.name.index(of: item.name)
                currentLocationNodeID = Constants.beaconsInfo.nodeID[i!]
                if currentLocationNodeID != lastCurrentLocationNodeID  {
                    if pathPlanned{
                        if destinationNodeID == Constants.beaconsInfo.nodeID[i!]{
                            currentLocationLabel.text = ("Arrivaled \(Constants.beaconsInfo.name[i!])")
                            
                        }else if !path.contains(Constants.beaconsInfo.nodeID[i!]) {
                            currentLocationLabel.text = ("Wrong Direction! Please Plan Again!")
                        }else {
                            currentLocationLabel.text = ("Current Location: \(Constants.beaconsInfo.name[i!])")
                        }
                    }else{
                        currentLocationLabel.text = ("Current Location: \(Constants.beaconsInfo.name[i!])")
                        //currentLocationNodeID = Constants.beaconsInfo.nodeID[i!]
                    }
                    drawCurrentLocation()
                    lastCurrentLocationNodeID = currentLocationNodeID
                }
            default: break
            }
        }
    }
    
}

