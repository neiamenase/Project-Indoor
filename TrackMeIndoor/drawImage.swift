//
//  drawImage.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation
import UIKit

class drawImage{
    func drawIBeaconLocation(startingImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        let ratio :Double = Double(startingImage.size.width / 10)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAlpha(0.5)
        context.setLineWidth(1.0)
        
        context.setFillColor(UIColor.green.cgColor)
        context.addEllipse(in: CGRect(x: Constants.BeaconA.locationX * ratio, y: Constants.BeaconA.locationY * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.yellow.cgColor)
        context.addEllipse(in: CGRect(x: Constants.BeaconB.locationX * ratio, y: Constants.BeaconB.locationY * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.orange.cgColor)
        context.addEllipse(in: CGRect(x: Constants.BeaconC.locationX * ratio, y: Constants.BeaconC.locationY * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.red.cgColor)
        context.addEllipse(in: CGRect(x: Constants.BeaconD.locationX * ratio, y: Constants.BeaconD.locationY * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    
    func drawMyLocation(startingImage: UIImage, x: Double, y: Double) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        let ratio :Double = Double(startingImage.size.width / 10)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAlpha(0.5)
        context.setLineWidth(1.0)
        
        let myLocationX = x / Constants.distanceUnit + 0.5
        let myLocationY = y / Constants.distanceUnit + 0.5
        print("x = \(myLocationX) Y = \(myLocationY)\n")
        context.setFillColor(UIColor.blue.cgColor)
        context.addEllipse(in: CGRect(x: myLocationX * ratio, y: myLocationY * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
}
