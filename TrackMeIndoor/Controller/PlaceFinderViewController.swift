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
    //@IBOutlet weak var infoMessageLabel: UILabel!
    //@IBOutlet weak var pathDescriptionTextView: UITextView!
    @IBOutlet weak var floorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var planPathButton: UIBarButtonItem!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    
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
    func drawPath(floor: Int, path: [Int]) -> Void{
        floorPlan[floor] = DrawImage().drawFloorPlanPathLocation(startingImage: floorPlan[floor]!, path: path)

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
    */
    @IBAction func floorChanged(_ sender: UISegmentedControl) {
        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
        
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
                let i = Constants.beaconsInfo.name.index(of: item.name)
                currentLocationLabel.text = item.name
//                for j in 0 ..< SearchPath.nodeInfoOnEachFloor.nodeRange.count{
//                    if SearchPath.nodeInfoOnEachFloor.nodeRange[j][0] <= i && SearchPath.nodeInfoOnEachFloor.nodeRange[j][1) >= Inti {
//                        if j != floorSegmentedControl.selectedSegmentIndex {
//                            floorSegmentedControl.selectedSegmentIndex = j
//                        imageView.image = floorPlan[floorSegmentedControl.selectedSegmentIndex]
//                        }
//                    }
//                }
                
                if Constants.beaconsInfo.nodeID[i!] == destinationNodeID{
//                    infoMessageLabel.text = "Arrivaled \(Constants.beaconsInfo.name[i!])"
                }else if Constants.beaconsInfo.nodeID[i!] == currentLocationNodeID{
                    continue
                }
                else if path.contains(Constants.beaconsInfo.nodeID[i!]) {
//                    infoMessageLabel.text = "You are in \(Constants.beaconsInfo.name[i!])"
                }else {
  //                  infoMessageLabel.text = "Wrong Direction! "
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
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        targetType = Constants.NodeType.allValues[row]
        // high all pts with targetTypex
    }

}



