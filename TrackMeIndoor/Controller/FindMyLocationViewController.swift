//
//  FindMyLocationViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 17/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class FindMyLocationViewController: UIViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var testText: UITextView!
    @IBOutlet weak var floorPlanImageView: UIImageView!
    @IBOutlet weak var displayMessage: UILabel!
    
    @IBOutlet weak var defaultValueButton: UIButton!
    let locationManager = CLLocationManager()
    var items = [Item]()
    var count = 0
    
    var floorPlan : UIImage = UIImage(named: "Grid")!
    
    var useDefaultValue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
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
    
    func viewForZooming(in scrollview: UIScrollView) -> UIView? {
        return self.floorPlanImageView
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
        for i in 0..<4 {
        items.append(Item(name: Constants.beaconsInfo.nodeDescription[i], icon: 0, uuid: Constants.uuid, majorValue: Constants.iBeaconMajor, minorValue: Constants.beaconsInfo.minor[i], distance: 0.0))
        }
        
        for item in items{
            startMonitoringItem(item)
        }
    }
 
    @IBAction func defaultValueAction(_ sender: Any) {
        if useDefaultValue {
            defaultValueButton.backgroundColor = UIColor.white
            defaultValueButton.setTitleColor(self.view.tintColor, for: .normal)
        }else{
            defaultValueButton.backgroundColor = self.view.tintColor
            defaultValueButton.setTitleColor(UIColor.white, for: .normal)
            
        }
        useDefaultValue = !useDefaultValue
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
//        for beacon in beacons {
//            for row in 0..<items.count {
//                // TODO: Determine if item is equal to ranged beacon
//                if items[row] == beacon {
//
//                    items[row].beacon = beacon
//                    items[row].distance = (items[row].distance * Double(items[row].count) + beacon.accuracy) / (Double(items[row].count) + 1)
//                    items[row].count += 1
//
//                    count += 1
//                }
//            }
//        }
//
//        if count == 8{
//
//            count = 0
//            let coordinate = getCoordinate(items)
//            testText.text = "x:\(String(format: "%.2f",coordinate!.x))   y:\(String(format: "%.2f",coordinate!.y))\n"
//            floorPlanImageView.image = DrawImage().drawMyLocation(startingImage: floorPlan, x: coordinate!.x, y: coordinate!.y)
//            displayMessage.text = " "
//            for item in items {
//                print("minor: \(item.minorValue), name: \(item.name), distance: \(item.distance)")
//                item.distance = 0.0
//                item.count = 0
//
//                testText.text = testText.text + "Name: \(item.name) \n" + item.locationString() + "\t\t\((item.beacon?.rssi)!)" + "\n"
//
//                switch item.beacon?.proximity{
//                case .immediate?:
//                    displayMessage.text = "You are in Location \(item.name)"
//                default: break
//
//                }
//            }
        for beacon in beacons {
            for row in 0..<items.count {
                    // TODO: Determine if item is equal to ranged beacon
                if items[row] == beacon {
                    items[row].beacon = beacon
                }
            }
        }

        
        displayMessage.text = " "
        if useDefaultValue{
            testText.text = "Default:\n"
        }else{
            testText.text = "Calibrataion:\n"
        }
        var item = items[0]
            //d = do * 10 ^ (Pr(d0) - Pr(d) ]  / 10n)
            if item.beacon != nil{
                if useDefaultValue{

                    item.distance = (item.beacon?.accuracy)!
                }else{
                    //let i = Constants.beaconsInfo.minor.index(of: Int(item.minorValue))
                    item.distance = (1.0 * pow(10.0, (Double(Constants.dZeroA) - Double((item.beacon?.rssi)!) ) / 10.0 / Double(Constants.nA)))
                }
                testText.text = testText.text + "Name: \(item.name) \n RSSI: \((item.beacon?.rssi)!)\tDistance: \(String(format: "%.4f",(item.distance)))" + "\n"
            }
                    switch item.beacon?.proximity{
                    case .immediate?:
                        displayMessage.text = "You are in Location \(item.name)"
                    default: break
                        
                    }
            //d = do * 10 ^ (Pr(d0) - Pr(d) ]  / 10n)
            item = items[1]
            if item.beacon != nil{
                if useDefaultValue{
                    
                    item.distance = (item.beacon?.accuracy)!
                }else{
                    //let i = Constants.beaconsInfo.minor.index(of: Int(item.minorValue))
                    item.distance = (1.0 * pow(10.0, (Double(Constants.dZeroB) - Double((item.beacon?.rssi)!) ) / 10.0 / Double(Constants.nB)))
                }
                testText.text = testText.text + "Name: \(item.name) \n RSSI: \((item.beacon?.rssi)!)\tDistance: \(String(format: "%.4f",(item.distance)))" + "\n"
            }
            switch item.beacon?.proximity{
            case .immediate?:
                displayMessage.text = "You are in Location \(item.name)"
            default: break
                
            }
            //d = do * 10 ^ (Pr(d0) - Pr(d) ]  / 10n)
            item = items[2]
            if item.beacon != nil{
                if useDefaultValue{
                    
                    item.distance = (item.beacon?.accuracy)!
                }else{
                    //let i = Constants.beaconsInfo.minor.index(of: Int(item.minorValue))
                    item.distance = (1.0 * pow(10.0, (Double(Constants.dZeroC) - Double((item.beacon?.rssi)!) ) / 10.0 / Double(Constants.nC)))
                }
                testText.text = testText.text + "Name: \(item.name) \n RSSI: \((item.beacon?.rssi)!)\tDistance: \(String(format: "%.4f",(item.distance)))" + "\n"
            }
            switch item.beacon?.proximity{
            case .immediate?:
                displayMessage.text = "You are in Location \(item.name)"
            default: break
                
            }
            //d = do * 10 ^ (Pr(d0) - Pr(d) ]  / 10n)
            item = items[3]
            if item.beacon != nil{
                if useDefaultValue{
                    
                    item.distance = (item.beacon?.accuracy)!
                }else{
                    //let i = Constants.beaconsInfo.minor.index(of: Int(item.minorValue))
                    item.distance = (1.0 * pow(10.0, (Double(Constants.dZeroD) - Double((item.beacon?.rssi)!) ) / 10.0 / Double(Constants.nD)))
                }
                testText.text = testText.text + "Name: \(item.name) \n RSSI: \((item.beacon?.rssi)!)\tDistance: \(String(format: "%.4f",(item.distance)))" + "\n"
            }
            switch item.beacon?.proximity{
            case .immediate?:
                displayMessage.text = "You are in Location \(item.name)"
            default: break
                
            }

        
        let coordinate = getCoordinate(items)
        testText.text = testText.text +  "x:\(String(format: "%.2f",coordinate!.x))   y:\(String(format: "%.2f",coordinate!.y))\n"
        floorPlanImageView.image = DrawImage().drawMyLocation(startingImage: floorPlan, x: coordinate!.x, y: coordinate!.y)
    }
    
    func getCoordinate (_ items: [Item]) -> Coordinates?{
        let a = items.first(where: {$0.minorValue == UInt16(Constants.beaconsInfo.minor[0])})
        let b = items.first(where: {$0.minorValue == UInt16(Constants.beaconsInfo.minor[1])})
        let c = items.first(where: {$0.minorValue == UInt16(Constants.beaconsInfo.minor[2])})
        let d = items.first(where: {$0.minorValue == UInt16(Constants.beaconsInfo.minor[3])})
        if (a != nil && b != nil && c != nil && d != nil) {
            return Coordinates((pow(Double(Constants.u),2) + pow(Double(b!.distance),2) - pow(Double(d!.distance),2)) / (2 * Constants.u),
                            (pow(Double(Constants.v),2) + pow(Double(c!.distance),2) - pow(Double(a!.distance),2)) / (2 * Constants.v))

        }else{
            return Coordinates(-10,-10)
        }
    }
    
    
    
    
}



















