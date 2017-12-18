//
//  FindSeatViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreMotion

class FindSeatViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    var currentCoordinates = Coordinates(100,100)
    
    
    var timer = Timer()
    var pl:PointLine = PointLine()
    var track:Tracking = Tracking()
    

    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var stopTrackingButton: UIButton!
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet weak var MasterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pl = PointLine(superView: MasterView)
    }
    
    
    func startTrackAccelerometer()->Void{
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
            if let accelerometerLog = data{
                print(accelerometerLog)
                let coordinates = Coordinates(accelerometerLog.acceleration.x, accelerometerLog.acceleration.y)
                print("\(coordinates.x)  \(coordinates.y)")
                self.currentCoordinates.x += coordinates.x * 100
                self.currentCoordinates.y += coordinates.y * 100
            }
        }

    }
    func stopTrackAccelerometer()->Void{
        motionManager.stopAccelerometerUpdates()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    @IBAction func startTracking(_ sender: Any) {
//        startTrackAccelerometer()
//    }
//    @IBAction func stopTracking(_ sender: Any) {
//        stopTrackAccelerometer()
//    }

    @IBAction func StartButton(sender: AnyObject) {
        TitleLabel.text = "Running!"
        track = Tracking()
        pl.addLineView()
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: Selector("drawLine"), userInfo: nil, repeats: true)
    }
    @IBAction func StopButton(sender: AnyObject) {
        TitleLabel.text = "Stopped!"
        timer.invalidate()
    }
    
    
    
    func drawLine(){
        track.update()
        var currentPoint:CGPoint = CGPoint(x: CGFloat(track.position_y*200+150), y: CGFloat(track.position_x*200+150))
        pl.drawLineToPoint(point: currentPoint)
    }
    
    
    @IBAction func CleanButton(sender: AnyObject) {
        TitleLabel.text = "Stopped!"
        pl.cleanView()
    }
}
