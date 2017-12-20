//
//  ReceiverViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 19/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class ReceiverViewController: UIViewController {

    @IBOutlet weak var phoneBeaconInfoLabel: UILabel!
    @IBOutlet weak var targetMinorTextField: UITextField!
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var startListenButton: UIButton!
    
    let locationManager = CLLocationManager()
    var startingListen = false
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        phoneBeaconInfoLabel.text = "UUID: \(Constants.uuid) \n\nMajor: \(Constants.firendMajor)\n\nMinor:"
        receivedMessageLabel.text = "~ Not Strat ~"
        
         locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func startReceivingSignal(_ sender: Any) {
        if !startingListen {
            if (targetMinorTextField.text?.isEmpty)!{
                return
            }
            let targetMinor = Int(targetMinorTextField.text!)!
            if targetMinor > 0 && targetMinor < 65535 {
                let item = Item(name: "phoneBeacon", icon: 0, uuid: Constants.uuid, majorValue: Constants.firendMajor, minorValue: targetMinor, distance: 0.0)
                startMonitoringItem(item)
                items.append(item)
                receivedMessageLabel.text = "Recevior started"
                startListenButton.setTitle("Stop Listen", for: UIControlState.normal)
                startingListen = !startingListen
            }
        }else{
            for item in items{
                self.stopMonitoringItem(item)
            }
            items.removeAll()
            receivedMessageLabel.text = "Recevior stopped"
            startListenButton.setTitle("Start Listen", for: UIControlState.normal)
        }
        
        
    }
    
}
extension ReceiverViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        // Find the same beacons in the table.
        
        
        // var indexPaths = [IndexPath]()
        for beacon in beacons {
            print("minor: \(beacon.minor)")
            for row in 0..<items.count {
                // TODO: Determine if item is equal to ranged beacon
                if items[row] == beacon {
                    items[row].beacon = beacon
                    print(items[row].name)
                    print(beacon.minor)
                }
            }
        }
        
        for item in items{
            receivedMessageLabel.text = item.locationString()
        }
    }
}

