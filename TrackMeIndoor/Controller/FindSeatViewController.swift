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


    var motionManager = CMMotionManager()
    
    var currentLocationX = Constants.findSeatStartPoint[0] * Constants.findSeatUnitSize
    var currentLocationY = Constants.findSeatStartPoint[1] * Constants.findSeatUnitSize
    var isTracking = false
    var zu : Double = 0.0 // in ms^-1
    var yu : Double = 0.0 // in ms
    var xu : Double = 0.0 // in ms
    var ratio : Double = 1.0
    var minValue = 0.0
    
    
    var xborderMax: Double = Constants.findSeatFloorPlanUnit[0] * Constants.findSeatUnitSize
    var yborderMax: Double = Constants.findSeatFloorPlanUnit[1] * Constants.findSeatUnitSize
    
    
    var timeInterval : Double = 0.5 // ∆T
    
    var floorPlanImage = UIImage(named: "F9Terrace")
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        print (currentLocationX, currentLocationY)
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
                    
                    //print(accelerometerLog)
//                    print("x: \(String(format: "%.2f", accelerometerLog.acceleration.x))   y:\(String(format: "%.2f", accelerometerLog.acceleration.y))")
                    let coordinates = Coordinates(accelerometerLog.acceleration.x, accelerometerLog.acceleration.y)
                    //print("\(coordinates.x)  \(coordinates.y)")
                    // s = ut + (1/2)(at²)
                    //            s   =      u       t              + 1/2                        a                          t^2
                    if abs(accelerometerLog.acceleration.y) > self.minValue && abs(accelerometerLog.acceleration.x) > self.minValue {
                        let zValue = accelerometerLog.acceleration.z * -1
                        print("x: \(String(format: "%.2f", accelerometerLog.acceleration.x))   y:\(String(format: "%.2f", accelerometerLog.acceleration.y)) z:\(String(format: "%.2f", zValue))")
                        
                        
                        
                    let deltaZInMeter = (self.zu * self.timeInterval) + (1/2 * zValue * self.timeInterval * self.timeInterval * self.ratio)
                    // now define +z => forward? seems match physical meaning. if not, please remove * -1
                    let deltaYInMeter = (self.yu * self.timeInterval) + (1/2 * (accelerometerLog.acceleration.y) * self.timeInterval * self.timeInterval * self.ratio)
                    let deltaXInMeter = (self.xu * self.timeInterval) + (1/2 * (accelerometerLog.acceleration.x) * self.timeInterval * self.timeInterval * self.ratio)
                    // -ve => left; +ve = Right
                    self.zu = zValue * self.timeInterval * self.ratio
                    self.yu = (accelerometerLog.acceleration.y) * self.timeInterval * self.ratio
                    self.xu = self.xu  + (accelerometerLog.acceleration.x) * self.timeInterval * self.ratio
                   print( "xu: \(String(format: "%.2f", self.xu))", "yu: \(String(format: "%.2f", self.yu))", "zu: \(String(format: "%.2f", self.zu))")
                        
                        
                        //print ("old: \(self.currentLocationX) , \(self.currentLocationY)")
                        
                        var x_change = self.currentLocationX + deltaXInMeter
                        var y_change = self.currentLocationY + deltaYInMeter
                        
                        if x_change < 0 {
                            x_change = 0
                        }
                        if y_change < 0 {
                            y_change = 0
                        }
                        
                        if x_change > self.xborderMax {
                            x_change = self.xborderMax
                        }
                        if y_change > self.yborderMax {
                            y_change = self.yborderMax
                        }
                        self.floorPlanImage = DrawImage().drawFlanSeatPath(startingImage: self.floorPlanImage!, startX: self.currentLocationX, startY: self.currentLocationY, stopX: sqrt((self.currentLocationX * self.currentLocationX) + (x_change * x_change)),
                                                   stopY: sqrt((self.currentLocationY * self.currentLocationY) + (y_change * y_change)))
                        self.imageView.image = self.floorPlanImage
                        self.currentLocationX = x_change
                        self.currentLocationY = y_change
                        //print ("new: \(self.currentLocationX) , \(self.currentLocationY)")
                    }else{
                        self.xu = 0
                        self.yu = 0
                        self.zu = 0
                        print ("stationary")
                    }
                    
                    
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
            self.xu = 0.0

            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(trackingAction))
            startTrackAccelerometer()
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(trackingAction))
            stopTrackAccelerometer()
        }
        isTracking = !isTracking
        
    }


}
