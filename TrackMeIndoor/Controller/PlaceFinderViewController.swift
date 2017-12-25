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
    @IBOutlet weak var floorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var planPathButton: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var pathDetailsTextView: UITextView!
    var floorPlan = Constants.floorPlanImage
    var currentLocationNodeID = -1
    var destinationNodeID = -1
    
    var items = [Item]()
    var path = [Int]()
    var timeCost = 0
    var startFloor = 0
    var endFloor = 0
    var pickerDataSource = Constants.NodeType.allValues;
    var targetType : Constants.NodeType = Constants.NodeType(rawValue: "Restaurant")!
    var locationManager = CLLocationManager()
    
    
    @IBAction func planPath(_ sender: Any) {
        let (cost, noOfNode, path) = SearchPath.SearchPathByNodeType(type: targetType, currentLoctionNodeID: 31)
        print(cost, noOfNode, path)
        if !path.isEmpty{
            drawPath(path: path)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        locationManager.delegate = self
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        loadItems()


    }
    
    func drawPath(path: [Int]) -> Void{
        var floor = Constants.floorPlanIndex.index(of:Int( Constants.storesDB[path[0]][3])!)
        var startIndex = 0
        var endIndex = 0
        for i in 0..<path.count{
            if floor != Constants.floorPlanIndex.index(of:Int( Constants.storesDB[path[i]][3])!){
                endIndex = i - 1
                let subPath = Array(path[startIndex..<endIndex])
                self.drawPathForEachFloor(floor: floor!, path: subPath)
                floor = Constants.floorPlanIndex.index(of:Int( Constants.storesDB[path[i]][3])!)
                startIndex = i
            }
        }
        let subPath = Array(path[endIndex...])
        self.drawPathForEachFloor(floor: floor!, path: subPath)
        floorPlan[floor!] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[floor!]!, x: SearchPath.coordinates[path[path.count-1]-1][0], y: SearchPath.coordinates[path[path.count-1]-1][1], color: UIColor.red.cgColor)
        
        drawCurrentLocation()
        
//        var startFloor = 0
//        var endFloor = 0
//        for i in 0..<SearchPath.nodeInfoOnEachFloor.nodeRange.count{
//            if path[0] >= SearchPath.nodeInfoOnEachFloor.nodeRange[i][0] && path[0] <= SearchPath.nodeInfoOnEachFloor.nodeRange[i][1]{
//                startFloor = i
//                floorSegmentedControl.selectedSegmentIndex = i
//            }
//            if path[path.count-1] >= SearchPath.nodeInfoOnEachFloor.nodeRange[i][0] && path[path.count-1] <= SearchPath.nodeInfoOnEachFloor.nodeRange[i][1]{
//                endFloor = i
//            }
//        }
//
//        if startFloor != endFloor{
//            for liftNum in 0..<SearchPath.nodeInfoOnEachFloor.floorChangedNodes[0].count{
//                let liftStartNode = path.index(of: SearchPath.nodeInfoOnEachFloor.floorChangedNodes[startFloor][liftNum])
//                let liftEndNode = path.index(of: SearchPath.nodeInfoOnEachFloor.floorChangedNodes[endFloor][liftNum])
//                if liftStartNode != nil && liftEndNode != nil{
//                    if liftStartNode == liftEndNode! - 1{
//                        let firstPath = Array(path[0..<liftEndNode!])
//                        drawPathForEachFloor(floor: startFloor, path: firstPath)
//                        let secondPath = Array(path[liftEndNode!...])
//                        drawPathForEachFloor(floor: endFloor, path: secondPath)
//                        break
//                    }
//                }
//            }
//
//
//        }else{
//            drawPathForEachFloor(floor: startFloor, path: path)
//        }
        
//        floorPlan[startFloor] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[startFloor]!, x: SearchPath.coordinates[path[0]-1][0], y: SearchPath.coordinates[path[0]-1][1], color: UIColor.green.cgColor)

        
      //  pathDescription()
//        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
//
        if items.isEmpty{
            loadItems()
            
        }
    }
    
    func drawPathForEachFloor(floor: Int, path: [Int]) -> Void{
        floorPlan[floor] = DrawImage().drawFloorPlanPathLocation(startingImage: floorPlan[floor]!, path: path)

    }
    
    func drawCurrentLocation() -> Void {
        if currentLocationNodeID != -1{
        floorSegmentedControl.selectedSegmentIndex = Constants.floorPlanIndex.index(of: Int(Constants.storesDB[currentLocationNodeID-1][3])!)!
        imageView.image = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[floorSegmentedControl.selectedSegmentIndex]!, x: SearchPath.coordinates[currentLocationNodeID-1][0], y: SearchPath.coordinates[currentLocationNodeID-1][1], color: UIColor.green.cgColor)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func loadItems() {
        for i in 0..<Constants.beaconsInfo.name.count{
            items.append(Item(name: Constants.beaconsInfo.name[i], icon: 0, uuid: Constants.uuid, majorValue: Constants.iBeaconMajor, minorValue: Constants.beaconsInfo.minor[i], distance: 0.0))
        }
        for item in items{
            startMonitoringItem(item)
        }
    }
    
    func drawAllStoreOnFloorPlan() -> Void {
        let selectedStores = Constants.storesDB.filter({$0[2] == targetType.rawValue})
        //var i = 0;
        for i in 0..<floorPlan.count{
            let stores = selectedStores.filter({$0[3] == String(Constants.floorPlanIndex[i])})
            for store in stores {
                var c = SearchPath.coordinates[Int(store[0])! - 1]
                floorPlan[i] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[i]!, x: c[0], y: c[1], color: UIColor.red.cgColor)
            }
        }
        
    }
    
    
    // MARK: - Scroll View
    func viewForZooming(in scrollview: UIScrollView) -> UIView? {
        return self.imageView
    }

    /*
    // MARK: - Navigation
    */
    @IBAction func floorChanged(_ sender: UISegmentedControl) {
        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
        
    }
    // MARK: - Moitoring iBeacon
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
    

}
// MARK: - iBeacon Extension
extension PlaceFinderViewController: CLLocationManagerDelegate{

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
                currentLocationLabel.text = "Current Location: \(item.name)"
                currentLocationNodeID = Constants.beaconsInfo.nodeID[Constants.beaconsInfo.minor.index(of: Int(item.minorValue))!]
                drawCurrentLocation()
                
            default: break
            }
        }
    }
}
extension PlaceFinderViewController:  UIPickerViewDataSource, UIPickerViewDelegate{
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        targetType = Constants.NodeType.allValues[row]
        
        // high all pts with targetTypex
        floorPlan = Constants.floorPlanImage
        drawAllStoreOnFloorPlan()
        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]!
        
        
    }

}



