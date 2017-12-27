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
    @IBOutlet weak var d0Value: UITextField!
    @IBOutlet weak var nValue: UITextField!
    @IBAction func barSaveButton(_ sender: Any) {
        Constants.v = acValue.text != nil ? Double(acValue.text!)!:2
        Constants.u = bdValue.text != nil ? Double(bdValue.text!)!:2
        Constants.dZero = d0Value.text != nil ? Double(d0Value.text!)!:2
        Constants.n = nValue.text != nil ? Double(nValue.text!)!:2
        saveSettings();
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acValue.text = String(format: "%d", Int(Constants.v))
        bdValue.text = String(format: "%d", Int(Constants.u))
        d0Value.text = String(format: "%d", Int(Constants.dZero))
        nValue.text = String(format: "%d", Int(Constants.n))
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
        Constants.dZero = -69
        Constants.n = 5.647277761
        acValue.text = String(format: "%d", Int(Constants.v))
        bdValue.text = String(format: "%d", Int(Constants.u))
            saveSettings();
            _ = navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
    }
    
    private func saveSettings() {
        
//        if Double(bdValue.text!) > 10.0 || Double(bdValue.text!) < 1.0 || Double(acValue.text!) > 10.0 || Double(acValue.text!) < 1.0 {
//            let alert = UIAlertController(title: "Input Error", message: "Range: 2-10", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(
            SaveSetting(
                u:Double(bdValue.text!)!,
                v:Double(acValue.text!)!
            ),
            toFile: Constants.SettingArchiveURL.path)
        if isSuccessfulSave {
            os_log("u v successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save u v ...", log: OSLog.default, type: .error)
        }
    }
    /*
    // MARK: - Navigation
    */

}
