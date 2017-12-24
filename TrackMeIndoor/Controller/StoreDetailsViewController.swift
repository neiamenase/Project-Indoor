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
    @IBOutlet weak var storeMapImageView: UIImageView!
    @IBOutlet weak var storeDetailsTextView: UITextView!
    @IBOutlet weak var floorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var goButton: UIButton!
    
 
    var store : Store? = nil
    
    var floorPlan = Constants.floorPlanImage
    var currentLocationNodeID = -1
    var destinationNodeID = -1
    
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
        var targetFloor : UIImage = floorPlan[Constants.floorPlanIndex.index(of:(store?.floor)!)!]!
        targetFloor = DrawImage().drawPointOnFloorPlan(startingImage: targetFloor, x: SearchPath.coordinates[(store?.nodeID)!-1][0], y: SearchPath.coordinates[(store?.nodeID)!-1][1], color: UIColor.red.cgColor)
        storeMapImageView.image = targetFloor
        storeDetailsTextView.text = store?.category
    }
    
    @IBAction func planPath(_ sender: Any) {
        if currentLocationNodeID == -1{
            let alert = UIAlertController(title: "Current Location Not Found", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
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
        
        
        currentLocationNodeID = -1
        currentLocationLabel.text = "Current Location: Searching..."
        
        
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
                currentLocationLabel.text = ("Current Location: \(Constants.beaconsInfo.name[i!])")
                currentLocationNodeID = Constants.beaconsInfo.nodeID[i!]
            default: break
            }
        }
    }
}

