//
//  EmitterViewController.swift
//  iBeacon Demo
//
//  Created by Darktt on 15/01/31.
//  Copyright (c) 2015年 Darktt. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class EmitterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    fileprivate var broadcasting: Bool = false
    
    fileprivate var beacon: CLBeaconRegion?
    fileprivate var peripheralManager: CBPeripheralManager?
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var beaconDetails: UITextView!
    @IBOutlet weak var beaconPickerView: UIPickerView!
    
    var pickerDataSource = Constants.beaconsInfo.name;
   // var tabBarController: Int beaconID = 0
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        beaconPickerView.dataSource = self
        beaconPickerView.delegate = self
        
        pickerDataSource.append("My Phone")
        
    }
    
    deinit
    {
        self.beacon = nil
        self.peripheralManager = nil
    }
    
    override func didReceiveMemoryWarning()
    {
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let major: CLBeaconMajorValue, minor:CLBeaconMinorValue
        if row < Constants.beaconsInfo.name.count {
            major = CLBeaconMajorValue(Constants.iBeaconMajor)
            minor = CLBeaconMinorValue(Constants.beaconsInfo.minor[row])
        }else{
            major = CLBeaconMajorValue(Constants.firendMajor)
            minor = CLBeaconMinorValue(arc4random() % 20 + 1)
        }
        self.beacon = CLBeaconRegion(proximityUUID: Constants.uuid, major: major, minor: minor, identifier: pickerDataSource[row])
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        beaconDetails.text = "UUID: \n\(Constants.uuid) \n\nMajor: \(major)\n\nMinor: \(minor)"
        
    }
}

// MARK: - Status Bar -

extension EmitterViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        if self.broadcasting {
            return .lightContent
        }
        
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return false
    }
}

//MARK: - Actions -

extension EmitterViewController
{
    @IBAction fileprivate func broadcastBeacon(sender: UIButton) -> Void
    {
        let state: CBManagerState = self.peripheralManager!.state
        
        if (state == .poweredOff && !self.broadcasting) {
            let OKAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            let alert: UIAlertController = UIAlertController(title: "Bluetooth OFF", message: "Please power on your Bluetooth!", preferredStyle: .alert)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let titleFromStatus: () -> String = {
            let title: String = (self.broadcasting) ? "Start" : "Stop"
            
            return title + " Broadcast"
        }
        
       // let buttonTitleColor: UIColor = (self.broadcasting) ? UIColor.iOS7BlueColor() : UIColor.iOS7WhiteColor()
        
        sender.setTitle(titleFromStatus(), for: UIControlState.normal)
       // sender.setTitleColor(buttonTitleColor, for: UIControlState.normal)
        
        let labelTextFromStatus: () -> String = {
            let text: String = (self.broadcasting) ? "Not Broadcast" : "Broadcasting..."
            
            return text
        }
        
        self.statusLabel.text = labelTextFromStatus()
        
        let animations: () -> Void = {
       //     let backgroundColor: UIColor = (self.broadcasting) ? UIColor.iOS7WhiteColor() : UIColor.iOS7BlueColor()
            
            //self.view.backgroundColor = backgroundColor
            
            self.broadcasting = !self.broadcasting
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        let completion: (Bool) -> Void = {
            finish in
            self.advertising(start: self.broadcasting)
        }
        
        UIView.animate(withDuration: 0.25, animations: animations, completion: completion)
    }
    
    // MARK: - Broadcast Beacon
    
    func advertising(start: Bool) -> Void
    {
        if self.peripheralManager == nil {
            return
        }
        
        if (!start) {
            self.peripheralManager!.stopAdvertising()
            
            return
        }
        
        let state: CBManagerState = self.peripheralManager!.state
        
        if (state == .poweredOn) {
            let UUID:UUID = (self.beacon?.proximityUUID)!
            let serviceUUIDs: Array<CBUUID> = [CBUUID(nsuuid: UUID)]
            
            // Why NSMutableDictionary can not convert to Dictionary<String, Any> 😂
            var peripheralData: Dictionary<String, Any> = self.beacon!.peripheralData(withMeasuredPower: 1)  as NSDictionary as! Dictionary<String, Any>
            peripheralData[CBAdvertisementDataLocalNameKey] = "iBeacon Demo"
            peripheralData[CBAdvertisementDataServiceUUIDsKey] = serviceUUIDs
            
            self.peripheralManager!.startAdvertising(peripheralData)
        }
    }
}

// MARK: - CBPeripheralManager Delegate -

extension EmitterViewController: CBPeripheralManagerDelegate
{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        let state: CBManagerState = peripheralManager!.state
        
        if state == .poweredOff {
            self.statusLabel.text = "Bluetooth Off"
            
            if self.broadcasting {
                self.broadcastBeacon(sender: self.triggerButton)
            }
        }
        
        if state == .unsupported {
            self.statusLabel.text = "Unsupported Beacon"
        }
        
        if state == .poweredOn {
            self.statusLabel.text = "Not Broadcast"
        }
    }
}

