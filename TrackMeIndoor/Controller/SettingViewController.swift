//
//  SettingViewController.swift
//  TrackMeIndoor
//
//  Created by apple on 23/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import os.log

class SettingViewController: UIViewController {

    @IBOutlet weak var acValue: UITextField!
    @IBOutlet weak var bdValue: UITextField!
    @IBAction func barSaveButton(_ sender: Any) {
        Constants.v = acValue.text != nil ? Double(acValue.text!)!:2
        Constants.u = bdValue.text != nil ? Double(bdValue.text!)!:2
        saveSettings();
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acValue.text = String(format: "%d", Int(Constants.v))
        bdValue.text = String(format: "%d", Int(Constants.u))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToDefault(_ sender: Any) {
            Constants.u = 2
            Constants.v = 2
            acValue.text = String(format: "%d", Int(Constants.v))
            bdValue.text = String(format: "%d", Int(Constants.u))
            saveSettings();
            _ = navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
    }
    
    private func saveSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(
            SaveSetting(
                u:Double(bdValue.text!)!,
                v:Double(acValue.text!)!
            ),
            toFile: Constants.SettingArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    /*
    // MARK: - Navigation
    */

}
