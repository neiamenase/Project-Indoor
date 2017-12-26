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
    var floorPlanWithCurrent = Constants.floorPlanImage
    var currentLocationNodeID = -1
    var lastCurrentLocationNodeID = -1
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
        if currentLocationNodeID < 0 {
            currentLocationNodeID = 31
            lastCurrentLocationNodeID = currentLocationNodeID
        }
        let (cost, noOfNode, path) = SearchPath.SearchPathByNodeType(type: targetType, currentLoctionNodeID: currentLocationNodeID)
        
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
        pathDetailsTextView.text = "Blue: Start Point\nRed: Feature Point\nGreen: Current Point \nTriangle: Lift"

    }
    
    func drawPath(path: [Int]) -> Void{
        var floor = Constants.floorPlanIndex.index(of:Int( Constants.storesDB[path[0]][3])!)
        var index = 0
        //draw Start Point
        floorPlan[floor!] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[floor!]!, x: SearchPath.coordinates[path[0]-1][0], y: SearchPath.coordinates[path[0]-1][1], color: UIColor.green.cgColor)
        for i in 1..<path.count{
            //print("test: i: \(i)  node:\(path[i])  per:\(floor!)  now:\(Constants.floorPlanIndex.index(of:Int(Constants.storesDB[path[i]-1][3])!)!)")
            if floor != Constants.floorPlanIndex.index(of:Int( Constants.storesDB[path[i]-1][3])!){
                let subPath = Array(path[index..<i])
              //  print(floor!, subPath)
                self.drawPathForEachFloor(floor: floor!, path: subPath)
                floorPlan = DrawImage().drawLiftPointFloorPlan(floorPlanImages: floorPlan as! [UIImage], startNode: path[i-1], endNode: path[i])
                floor = Constants.floorPlanIndex.index(of:Int( Constants.storesDB[path[i]-1][3])!)
                index = i
            }
        }
        let subPath = Array(path[index...])
        self.drawPathForEachFloor(floor: floor!, path: subPath)
        print(floor!, subPath)
        //draw end point
        floorPlan[floor!] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlan[floor!]!, x: SearchPath.coordinates[path[path.count-1]-1][0], y: SearchPath.coordinates[path[path.count-1]-1][1], color: UIColor.red.cgColor)
        floorPlanWithCurrent = floorPlan
        drawCurrentLocation()
        
        if items.isEmpty{
            loadItems()
            
        }
    }
    
    func drawPathForEachFloor(floor: Int, path: [Int]) -> Void{
        floorPlan[floor] = DrawImage().drawFloorPlanPathLocation(startingImage: floorPlan[floor]!, path: path)

    }
    
    func drawCurrentLocation() -> Void {
        if currentLocationNodeID >= 0 {
            floorSegmentedControl.selectedSegmentIndex = Constants.floorPlanIndex.index(of: Int(Constants.storesDB[currentLocationNodeID-1][3])!)!
            floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex] = DrawImage().drawPointOnFloorPlan(startingImage: floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex]!, x: SearchPath.coordinates[currentLocationNodeID-1][0], y: SearchPath.coordinates[currentLocationNodeID-1][1], color: UIColor.blue.cgColor)
            imageView.image = floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex]
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
        floorPlanWithCurrent = floorPlan
        
    }
    
    
    // MARK: - Scroll View
    func viewForZooming(in scrollview: UIScrollView) -> UIView? {
        return self.imageView
    }

    /*
    // MARK: - Navigation
    */
    @IBAction func floorChanged(_ sender: UISegmentedControl) {
        imageView.image = floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex]
        
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
                currentLocationNodeID = Constants.beaconsInfo.nodeID[Constants.beaconsInfo.minor.index(of: Int(item.minorValue))!]
                
                if currentLocationNodeID != lastCurrentLocationNodeID{
                    print(lastCurrentLocationNodeID, currentLocationNodeID)
                    currentLocationLabel.text = "Current Location: \(item.name)"
                    floorPlanWithCurrent = floorPlan
                    drawCurrentLocation()
                    lastCurrentLocationNodeID = currentLocationNodeID
                }
                
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
        lastCurrentLocationNodeID = -1
        imageView.image = floorPlanWithCurrent[floorSegmentedControl.selectedSegmentIndex]!
        
        
    }

}



