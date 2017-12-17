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
    
    let locationManager = CLLocationManager()
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        loadItems()
        
        
        //draw point on map
        
        //let lineView = LineView(frame: floorPlanImageView.frame)
        //floorPlanImageView.addSubview(lineView)
        var floorPlan : UIImage = UIImage(named: "Grid")!
        floorPlan = drawIBeaconLocation(startingImage: floorPlan)
        floorPlanImageView.image = floorPlan
        //self.view.addSubview(floorPlanImageView!)

        
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
        items.append(Item(name: Constants.BeaconA.name, icon: 0, uuid: Constants.uuid, majorValue: Constants.major, minorValue: Constants.BeaconA.minor, distance: 0.0))
        items.append(Item(name: Constants.BeaconB.name, icon: 0, uuid: Constants.uuid, majorValue: Constants.major, minorValue: Constants.BeaconB.minor, distance: 0.0))
        items.append(Item(name: Constants.BeaconC.name, icon: 0, uuid: Constants.uuid, majorValue: Constants.major, minorValue: Constants.BeaconC.minor, distance: 0.0))
        items.append(Item(name: Constants.BeaconD.name, icon: 0, uuid: Constants.uuid, majorValue: Constants.major, minorValue: Constants.BeaconD.minor, distance: 0.0))
        for item in items{
            startMonitoringItem(item)
        }
    }
    
    func drawIBeaconLocation(startingImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        let ratio = startingImage.size.width / 10
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAlpha(0.5)
        context.setLineWidth(1.0)
        
        
        context.setFillColor(UIColor.green.cgColor)
        context.addEllipse(in: CGRect(x: 4.5 * ratio, y: 0.5 * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.yellow.cgColor)
        context.addEllipse(in: CGRect(x: ratio/2, y: 4.5 * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.red.cgColor)
        context.addEllipse(in: CGRect(x: 4.5 * ratio, y: 8.5 * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.orange.cgColor)
        context.addEllipse(in: CGRect(x: 8.5 * ratio, y: 4.5 * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
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

    
}

extension FindMyLocationViewController: CLLocationManagerDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let item = items[indexPath.row]
//        let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
//        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
//        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(detailAlert, animated: true, completion: nil)
//    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        // Find the same beacons in the table.
        
        
        var indexPaths = [IndexPath]()
        for beacon in beacons {
            for row in 0..<items.count {
                // TODO: Determine if item is equal to ranged beacon
                if items[row] == beacon {
                    items[row].beacon = beacon
                    items[row].distance = beacon.accuracy
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        testText.text = ""
        
        var position = getCoordinate(items)
        testText.text = "x:\(position!.x)   y:\(position!.y)\n"
        for item in items {
            
            testText.text = testText.text + "Name: \(item.name) \n" + item.locationString() + "\nRSSI: \(item.beacon?.rssi)\n\n"
        }
    }
    
    func getCoordinate (_ items: [Item]) -> Position?{
        let a = items.first(where: {$0.minorValue == UInt16(Constants.BeaconA.minor)})
        let b = items.first(where: {$0.minorValue == UInt16(Constants.BeaconB.minor)})
        let c = items.first(where: {$0.minorValue == UInt16(Constants.BeaconC.minor)})
        let d = items.first(where: {$0.minorValue == UInt16(Constants.BeaconD.minor)})
        if (a != nil && b != nil && c != nil && d != nil) {
            return Position((sqrt(Constants.u) + sqrt(b!.distance) - sqrt(d!.distance)) / 2 * Constants.u,
                            (sqrt(Constants.v) + sqrt(a!.distance) - sqrt(c!.distance)) / 2 * Constants.v)

        }else{
            return nil
        }
    }
    
    
    
    
}



















