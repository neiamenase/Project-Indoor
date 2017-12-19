//
//  PlaceFinderFirstViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 19/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceFinderFirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var destinationPickerView: UIPickerView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    //let placeFinderFirstVC = PlaceFinderFirstViewController()
    let locationManager = CLLocationManager()
    var items = [Item]()
    var pickerDataSource = Constants.beaconsInfo.nodeDescription;
    
    var currentLocationNodeID = -1
    var destinationNodeID = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorMessageLabel.isHidden = true
        
        
        locationManager.delegate = self
        destinationPickerView.dataSource = self
        destinationPickerView.delegate = self

        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        destinationNodeID = Constants.beaconsInfo.nodeID[row]
        print("row:\(row) dest:\(Constants.beaconsInfo.nodeDescription[row]) id:\(Constants.beaconsInfo.nodeID[row])")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PlaceFinderViewController
        {
            

            let vc = segue.destination as? PlaceFinderViewController
            vc?.currentLocationNodeID = currentLocationNodeID
            vc?.destinationNodeID = destinationNodeID
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if currentLocationNodeID == -1{
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "Current Location Not Found"
            return false
        }
        
        destinationNodeID = Constants.beaconsInfo.nodeID[destinationPickerView.selectedRow(inComponent: 0)]
        if currentLocationNodeID == destinationNodeID{
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "You already arrivaled"
            return false
        }
        errorMessageLabel.isHidden = true
        return true
    }

    
}
extension PlaceFinderFirstViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        currentLocationNodeID = -1
        currentLocationLabel.text = "Searching..."
        
        
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
            case .immediate?, .near?:
                let i = Constants.beaconsInfo.name.index(of: item.name)
                currentLocationLabel.text = Constants.beaconsInfo.nodeDescription[i!]
                currentLocationNodeID = Constants.beaconsInfo.nodeID[i!]
                default: break
                }
            }
        }
}
