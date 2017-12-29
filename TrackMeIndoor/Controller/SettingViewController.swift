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
    
    @IBOutlet weak var nAValue: UITextField!
    @IBOutlet weak var nCValue: UITextField!
    @IBOutlet weak var nBValue: UITextField!
    @IBOutlet weak var nDValue: UITextField!
    @IBOutlet weak var pdZeroAValue: UITextField!
    @IBOutlet weak var pdZeroBValue: UITextField!
    @IBOutlet weak var pdZeroCValue: UITextField!
    @IBOutlet weak var pdZeroDValue: UITextField!
    
    @IBAction func barSaveButton(_ sender: Any) {
        Constants.v = acValue.text != nil ? Double(acValue.text!)!:2
        Constants.u = bdValue.text != nil ? Double(bdValue.text!)!:2
        if nAValue.text != nil{
            Constants.nA = Double(nAValue.text!)!
        }
        if nBValue.text != nil{
            Constants.nB = Double(nBValue.text!)!
        }
        if nCValue.text != nil{
            Constants.nC = Double(nCValue.text!)!
        }
        if nDValue.text != nil{
            Constants.nD = Double(nDValue.text!)!
        }
        if pdZeroAValue.text != nil{
            Constants.dZeroA = Int(pdZeroAValue.text!)!
        }
        if pdZeroBValue.text != nil{
            Constants.dZeroB = Int(pdZeroBValue.text!)!
        }
        if pdZeroCValue.text != nil{
            Constants.dZeroC = Int(pdZeroCValue.text!)!
        }
        if pdZeroDValue.text != nil{
            Constants.dZeroD = Int(pdZeroDValue.text!)!
        }
        
        
        
        saveSettings();
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acValue.text = String(format: "%.2f", Double(Constants.v))
        bdValue.text = String(format: "%.2f", Double(Constants.u))
        nAValue.text = String(format: "%f", Double(Constants.nA))
        pdZeroAValue.text = String(format: "%d", Int(Constants.dZeroA))
        nBValue.text = String(format: "%f", Double(Constants.nB))
        pdZeroBValue.text = String(format: "%d", Int(Constants.dZeroB))
        nCValue.text = String(format: "%f", Double(Constants.nC))
        pdZeroCValue.text = String(format: "%d", Int(Constants.dZeroC))
        nDValue.text = String(format: "%f", Double(Constants.nD))
        pdZeroDValue.text = String(format: "%d", Int(Constants.dZeroD))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToDefault(_ sender: Any) {
            Constants.u = 2
            Constants.v = 2
            Constants.nA = Constants._n
            Constants.dZeroA = Constants._dZero
            Constants.nB = Constants._n
            Constants.dZeroB = Constants._dZero
            Constants.nC = Constants._n
            Constants.dZeroC = Constants._dZero
            Constants.nD = Constants._n
            Constants.dZeroD = Constants._dZero
            acValue.text = String(format: "%.2f", Int(Constants.v))
            bdValue.text = String(format: "%.2f", Int(Constants.u))
            nAValue.text = String(format: "%f", Double(Constants.nA))
            pdZeroAValue.text = String(format: "%d", Int(Constants.dZeroA))
            nBValue.text = String(format: "%f", Double(Constants.nB))
            pdZeroBValue.text = String(format: "%d", Int(Constants.dZeroB))
            nCValue.text = String(format: "%f", Double(Constants.nC))
            pdZeroCValue.text = String(format: "%d", Int(Constants.dZeroC))
            nDValue.text = String(format: "%f", Double(Constants.nD))
            pdZeroDValue.text = String(format: "%d", Int(Constants.dZeroD))
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
                v:Double(acValue.text!)!,
                nA:Double(nAValue.text!)!,
                dZeroA: Int(pdZeroAValue.text!)!,
                nB:Double(nBValue.text!)!,
                dZeroB: Int(pdZeroBValue.text!)!,
                nC:Double(nCValue.text!)!,
                dZeroC: Int(pdZeroCValue.text!)!,
                nD:Double(nDValue.text!)!,
                dZeroD: Int(pdZeroDValue.text!)!
            ),
            toFile: Constants.SettingArchiveURL.path)
        if isSuccessfulSave {
            os_log("values successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save u v ...", log: OSLog.default, type: .error)
        }
    }
    /*
    // MARK: - Navigation
    */

}
