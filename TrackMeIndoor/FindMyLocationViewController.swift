//
//  FindMyLocationViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 17/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation
class FindMyLocationViewController: UIViewController {

    @IBOutlet weak var testText: UITextView!
    @IBOutlet weak var refreshButton: UIButton!
    let locationManager = CLLocationManager()
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        
        //locationManager.delegate = self
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Monitoring
    
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
        let txtUUID = "B5b182c7-eab1-4988-aa99-b5c1517008d9"
        let uuidString = txtUUID.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let uuid = UUID(uuidString: uuidString) else { return }
        let major = 1
        let minor = 58633
        let txtName = "A"
        let name = txtName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let newItem = Item(name: name, icon: 0, uuid: uuid, majorValue: major, minorValue: minor, distance: 0.0)
        items.append(newItem)
        
        
        //for itemData in storedItems {
//            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Item else { continue }
//            items.append(item)
//            startMonitoringItem(item)
//        }
    }
//    func persistItems() {
//        var itemsData = [Data]()
//        for item in items {
//            let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
//            itemsData.append(itemData)
//        }
//        UserDefaults.standard.set(itemsData, forKey: storedItemsKey)
//        UserDefaults.standard.synchronize()
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueAdd", let viewController = segue.destination as? AddItemViewController {
//            viewController.delegate = self
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func refreshLocation(_ sender: UIButton) {
        for item in items {
            testText.text = "A:" + item.locationString()
        }
    }
    
    func CalLocation (_ items: [Item]) -> Position?{

        let a = items.first(where: {$0.minorValue == UInt16(Constants.Beacon_A.minor)})
        let b = items.first(where: {$0.minorValue == UInt16(Constants.Beacon_B.minor)})
        let c = items.first(where: {$0.minorValue == UInt16(Constants.Beacon_C.minor)})
        let d = items.first(where: {$0.minorValue == UInt16(Constants.Beacon_D.minor)})
        
        if (a != nil && b != nil && c != nil && d != nil) {
            let u = Constants.u
            let v = Constants.v
            //     a
            //  b     d
            //     c
            
            var x = sqrt(u) + sqrt(b!.distance) - sqrt(d!.distance)
            x = x / 2 * u
            
            var y = sqrt(v) + sqrt(a!.distance) - sqrt(c!.distance)
            y = y / 2 * v
            
            return Position(x, y)

        }
        return nil
        
    }
    
    
    
    
}



















