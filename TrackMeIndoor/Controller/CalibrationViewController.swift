//
//  PlaceFinderFirstViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 19/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class CalibrationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var rssiLabel : UILabel!
    @IBOutlet weak var destinationPickerView: UIPickerView!

    @IBOutlet weak var beaconInfoTextView: UITextView!
    @IBOutlet weak var startButton: UIButton!
    //let placeFinderFirstVC = PlaceFinderFirstViewController()
    let locationManager = CLLocationManager()
    
    var items = [Item]()
    var pickerDataSource = Constants.beaconsInfo.nodeDescription[..<4];
    
    var targetBeacon : String = ""
    
    var count : Int = 0
    var totalRssi : Int = 0
    var isTracking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        //rrorMessageLabel.isHidden = true
        
        
        locationManager.delegate = self
        loadItems()
        destinationPickerView.dataSource = self
        destinationPickerView.delegate = self
        
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        targetBeacon = pickerDataSource[row]
        count  = 0
        totalRssi  = 0

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
        for i in 0..<4 {
            items.append(Item(name: Constants.beaconsInfo.nodeDescription[i], icon: 0, uuid: Constants.uuid, majorValue: Constants.iBeaconMajor, minorValue: Constants.beaconsInfo.minor[i], distance: 0.0))
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.destination is PlaceFinderViewController
//        {
//            let vc = segue.destination as? PlaceFinderViewController
//            vc?.currentLocationNodeID = currentLocationNodeID
//            vc?.destinationNodeID = destinationNodeID
//        }
//    }
//
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if currentLocationNodeID == -1{
//            errorMessageLabel.isHidden = false
//            errorMessageLabel.text = "Current Location Not Found"
//            return false
//        }
//
//        destinationNodeID = Constants.beaconsInfo.nodeID[destinationPickerView.selectedRow(inComponent: 0)]
//        if currentLocationNodeID == destinationNodeID{
//            errorMessageLabel.isHidden = false
//            errorMessageLabel.text = "You already arrivaled"
//            return false
//        }
//        errorMessageLabel.isHidden = true
//        return true
//    }


    @IBAction func startCal(_ sender: Any) {
        if !isTracking{
            count = 0
            totalRssi = 0
            startButton.setTitle("Stop", for: .normal)
        }else{
            startButton.setTitle("Start", for: .normal)
        }
        isTracking = !isTracking
        
        
    }
    
}
extension CalibrationViewController: CLLocationManagerDelegate{
    
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
        
        beaconInfoTextView.text = ""
        for item in items {
            
            if item.beacon != nil{
               // print (item.name, targetBeacon)
                if isTracking && item.name == targetBeacon && item.beacon?.rssi != 0 {
                    print (item.name, targetBeacon, item.beacon?.rssi)
                    count += 1
                    totalRssi += (item.beacon?.rssi)!
                    rssiLabel.text = "Count:\(count)  Avg RSSI: \(totalRssi / count)"
                }
                beaconInfoTextView.text = beaconInfoTextView.text + "Name: \(item.name) \n" + item.locationString() + "\t\t\((item.beacon?.rssi)!)" + "\n"
           
            }
            }
        }
}
