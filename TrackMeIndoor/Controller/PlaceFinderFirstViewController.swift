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
    let locationManager = CLLocationManager()
    var items = [Item]()
    var pickerDataSource = Constants.BeaconsInfo.nodeDescription;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        destinationPickerView.dataSource = self;
        destinationPickerView.delegate = self;

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
        for i in 0..<Constants.BeaconsInfo.name.count{
            items.append(Item(name: Constants.BeaconsInfo.name[i], icon: 0, uuid: Constants.uuid, majorValue: Constants.iBeaconMajor, minorValue: Constants.BeaconsInfo.minor[i], distance: 0.0))
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

}
extension PlaceFinderFirstViewController: CLLocationManagerDelegate{
    
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
            case .immediate?, .near?:
                let i = Constants.BeaconsInfo.name.index(of: item.name)
                currentLocationLabel.text = Constants.BeaconsInfo.nodeDescription[i!]
                default: break
                }
            }
        }
}
