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
   // @IBOutlet weak var trackButton: UIBarButtonItem!


    var motionManager = CMMotionManager()
    
    var currentLocationX = Constants.findSeatStartPoint[0] * Constants.findSeatUnitSize
    var currentLocationY = Constants.findSeatStartPoint[1] * Constants.findSeatUnitSize
    var isTracking = false
    var zu : Double = 0.0 // in ms^-1
    var yu : Double = 0.0 // in ms
    var xu : Double = 0.0 // in ms
    var ratio : Double = 1
    var minValue = 0.1
    var maxValue = 1.5
    var cosineValue = 0.0
    var _direction = ""
    
    var xborderMax: Double = Constants.findSeatFloorPlanUnit[0] * Constants.findSeatUnitSize
    var yborderMax: Double = Constants.findSeatFloorPlanUnit[1] * Constants.findSeatUnitSize
    
    
    var timeInterval : Double = 0.2 // ∆T
    
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
                    print("x: \(String(format: "%.2f", accelerometerLog.acceleration.x))   y:\(String(format: "%.2f", accelerometerLog.acceleration.y))")
                    if abs(accelerometerLog.acceleration.y) > self.minValue && abs(accelerometerLog.acceleration.y) < self.maxValue
                    {
                        // now define +z => forward? seems match physical meaning. if not, please remove * -1
                        let deltaYInMeter = (self.yu * self.timeInterval) + (1/2 * (accelerometerLog.acceleration.y) * self.timeInterval * self.timeInterval * self.ratio)
                        
                        // -ve => left; +ve = Right
                        self.yu = (accelerometerLog.acceleration.y) * self.timeInterval * self.ratio
                        //self.xu = self.xu + (accelerometerLog.acceleration.x) * self.timeInterval * self.ratio
                        
                        //print ("old: \(self.currentLocationX) , \(self.currentLocationY)")
                            
                            if abs(accelerometerLog.acceleration.x) > self.minValue && abs(accelerometerLog.acceleration.x) < self.maxValue{
                                let deltaXInMeter = (self.xu * self.timeInterval) + (1/2 * (accelerometerLog.acceleration.x) * self.timeInterval * self.timeInterval * self.ratio)
                                self.cosineValue = deltaYInMeter / sqrt(pow(abs(deltaYInMeter),2) + pow(abs(deltaXInMeter),2))
                                if deltaXInMeter > 0 {
                                    self._direction = "L"
                                }else{
                                    self._direction = "R"
                                }
                            }
                        
                        var newX = self.currentLocationX
                        if self._direction != "" {
                            if self._direction == "L"{
                                newX = self.currentLocationX + (deltaYInMeter / self.cosineValue)
                            }else if self._direction == "R"{
                                newX = self.currentLocationX - (deltaYInMeter / self.cosineValue)
                            }
                        }
                        var newY = self.currentLocationY + deltaYInMeter
                        if newX < 0 {
                            newX = 0
                        }
                        if newY < 0 {
                            newY = 0
                        }
                        if newX > self.xborderMax {
                            newX = self.xborderMax
                        }
                        if newY > self.yborderMax {
                            newY = self.yborderMax
                        }
                        self.floorPlanImage = DrawImage().drawFlanSeatPath(startingImage: self.floorPlanImage!, startX: self.currentLocationX, startY: self.currentLocationY, stopX: newX, stopY: newY)
                        self.imageView.image = DrawImage().drawFlanSeatCurrentPoint(startingImage: self.floorPlanImage!, x: newX, y: newY)
                        self.currentLocationX = newX
                        self.currentLocationY = newY
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
