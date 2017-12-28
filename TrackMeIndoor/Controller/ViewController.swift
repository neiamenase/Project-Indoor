//
//  ViewController.swift
//  TrackMeIndoor
//
//  Created by apple on 3/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestAlwaysAuthorization()
        if let setting = loadSettings() {
            if setting.u > 0 && setting.v > 0 {
                Constants.u = setting.u
                Constants.v = setting.v
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadSettings() -> SaveSetting?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Constants.SettingArchiveURL.path) as? SaveSetting
    }


}

