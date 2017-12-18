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
    @IBOutlet weak var floorPlanImageView: UIImageView!
    @IBOutlet weak var displayMessage: UILabel!
    
    let locationManager = CLLocationManager()
    var items = [Item]()
    var count = 0
    
    var floorPlan : UIImage = UIImage(named: "Grid")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        loadItems()
        
        
        //draw point on map
        
        floorPlan = DrawImage().drawIBeaconLocation(startingImage: floorPlan)
        floorPlanImageView.image = floorPlan


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func loadItems() {
        for i in 0..<Constants.BeaconsInfo.Name.count {
        items.append(Item(name: Constants.BeaconsInfo.Name[i], icon: 0, uuid: Constants.uuid, majorValue: Constants.iBeaconMajor, minorValue: Constants.BeaconsInfo.Minor[i], distance: 0.0))
        }
        for item in items{
            startMonitoringItem(item)
        }
    }
 
    
}

extension FindMyLocationViewController: CLLocationManagerDelegate{

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
            for row in 0..<items.count {
                // TODO: Determine if item is equal to ranged beacon
                if items[row] == beacon {
                    items[row].beacon = beacon
                    //items[row].distance = beacon.accuracy
                    items[row].distance = (items[row].distance * Double(items[row].count) + beacon.accuracy) / (Double(items[row].count) + 1)
                    items[row].count += 1
                   // indexPaths += [IndexPath(row: row, section: 0)]
                    count += 1
                }
            }
        }
        
        if count == Constants.counter{
            count = 0
            let coordinate = getCoordinate(items)
            testText.text = "x:\(String(format: "%.2f",coordinate!.x))   y:\(String(format: "%.2f",coordinate!.y))\n"
            floorPlanImageView.image = DrawImage().drawMyLocation(startingImage: floorPlan, x: coordinate!.x, y: coordinate!.y)
            displayMessage.text = " "
            for item in items {
                item.distance = 0.0
                item.count = 0
                
                testText.text = testText.text + "Name: \(item.name) \n" + item.locationString() + "\n"

                switch item.beacon?.proximity{
                case .immediate?:
                    displayMessage.text = "You are in Location \(item.name)"
                    floorPlanImageView.image = DrawImage().drawMyLocationImmediate(startingImage: floorPlan, minor: Int(item.minorValue))
                    //print ("\(item.name)  \(item.minorValue)")
                default: break
                    
                }
            }
        }
    }
    
    func getCoordinate (_ items: [Item]) -> Coordinates?{
        let a = items.first(where: {$0.minorValue == UInt16(Constants.BeaconsInfo.Minor[0])})
        let b = items.first(where: {$0.minorValue == UInt16(Constants.BeaconsInfo.Minor[1])})
        let c = items.first(where: {$0.minorValue == UInt16(Constants.BeaconsInfo.Minor[2])})
        let d = items.first(where: {$0.minorValue == UInt16(Constants.BeaconsInfo.Minor[3])})
        if (a != nil && b != nil && c != nil && d != nil) {
            return Coordinates((sqrt(Constants.u) + sqrt(b!.distance) - sqrt(d!.distance)) / 2 * Constants.u,
                            (sqrt(Constants.v) + sqrt(a!.distance) - sqrt(c!.distance)) / 2 * Constants.v)

        }else{
            return Coordinates(-10,-10)
        }
    }
    
    
    
    
}


















