//
//  FindSeatViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit
import CoreMotion

class FindSeatViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var trackButton: UIBarButtonItem!

    let floorPlanUnit = [14, 70] //x , y
    let unitSize = 0.254 // in meter ~ 25.4cm = 10 inch
    var motionManager = CMMotionManager()
    let startPoint = [5,9]
    var currentLocation = [5,9]
    var isTracking = false
    var zu : Double = 0.0 // in ms^-1
    var yu : Double = 0.0 // in ms
    var timeInterval : Double = 0.5 // ∆T
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // startTrackingButton
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
    
    
    func startTrackAccelerometer()->Void{
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = timeInterval
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
                if let accelerometerLog = data{
                    print(accelerometerLog)
                    let coordinates = Coordinates(accelerometerLog.acceleration.x, accelerometerLog.acceleration.y)
                    //print("\(coordinates.x)  \(coordinates.y)")
                    // s = ut + (1/2)(at²)
                    //            s   =      u       t              + 1/2                        a                          t^2

                    var deltaZInMeter = (self.zu * self.timeInterval) + (1/2 * (accelerometerLog.acceleration.z) * -1 * self.timeInterval * self.timeInterval * 9.8)
                    // now define +z => forward? seems match physical meaning. if not, please remove * -1
                    var deltaYInMeter = (self.yu * self.timeInterval) + (1/2 * (accelerometerLog.acceleration.y) * self.timeInterval * self.timeInterval * 9.8)
                    // -ve => left; +ve = Right
                    self.zu = self.zu + (accelerometerLog.acceleration.z) * -1 * self.timeInterval * 9.8
                    self.yu = self.yu + (accelerometerLog.acceleration.y) * self.timeInterval * 9.8
                    
                    /*
                    By Apple
                     https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events
                     
                     The values reported by the accelerometers are measured in increments of the gravitational acceleration, with the value 1.0 representing an
                     acceleration of 9.8 meters per second (per second) in the given direction.
                     
                     And,           (Home button and screen showing To u)
                     
                                               ^ +Y
                                               |
                                  -x <--    [phone ]    --> +x      ((X) -z)       ((O) +z)
                                               |                    into paper     outof paper
                                               v -Y
                     
                     (X -z) , (-> +x) and (<- -x)  are the keys
                     
                     so, (Only by Sam)
                     value :  meters per second (per second)
                     1 : 9.8ms -²
                     
                     s = ut + 1/2 at²
                     v = u + at
                     
                     t = accelerometerUpdateInterval = ∆T
                     u = 0
                     first reading:
                     1. z axis:
                        given: (+ve = backward; -ve = forward)
                        s = u + 1/2(-1*z)∆T²
                     2. y axis: (-x = left; +x = right)
                        s = u + 1/2(x)∆T²
                     ----------------
                     u = u + a(∆T)
                     where a belongs to (-z, y)
                    */
                    
                }
            }
        }
    }
    func stopTrackAccelerometer()->Void{
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollview: UIScrollView) -> UIView? {
        return self.imageView
    }
    // MARK: - Navigation
    @IBAction func trackingAction(_ sender: Any) {
        if !isTracking {
            self.zu = 0.0
            self.yu = 0.0
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(trackingAction))
            startTrackAccelerometer()
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(trackingAction))
            stopTrackAccelerometer()
        }
        isTracking = !isTracking
        
    }


}
