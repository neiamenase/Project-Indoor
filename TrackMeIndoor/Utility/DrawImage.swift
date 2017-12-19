//
//  DrawImage.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation
import UIKit

class DrawImage{
    func drawIBeaconLocation(startingImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        let ratio :Double = Double(startingImage.size.width / 10)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAlpha(0.5)
        //context.setLineWidth(1.0)
        
        
        for i in 0..<4{
            context.setFillColor(Constants.beaconsInfo.color[i])
            let coordinateX = Constants.findMyLocationCoordinate[i][0] / Constants.distanceUnit + 0.5
            let coordinateY = Constants.findMyLocationCoordinate[i][1] / Constants.distanceUnit + 0.5
            context.addEllipse(in: CGRect(x: coordinateX * ratio, y: coordinateY * ratio, width: ratio, height: ratio))
            context.drawPath(using: .fillStroke)
        }
       
        
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
        //context.setLineWidth(1.0)
        
        let myLocationX = x / Constants.distanceUnit + 0.5
        let myLocationY = y / Constants.distanceUnit + 0.5
        //print("x = \(myLocationX) Y = \(myLocationY)\n")
        context.setFillColor(UIColor.blue.cgColor)
        context.addEllipse(in: CGRect(x: myLocationX * ratio, y: myLocationY * ratio, width: ratio, height: ratio))
        context.drawPath(using: .fillStroke)
        

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    
    func drawMyLocationImmediate(startingImage: UIImage, minor: Int) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        let ratio :Double = Double(startingImage.size.width / 10)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAlpha(0.5)
        
        let i = Constants.beaconsInfo.minor.index(of: minor)
        context.setFillColor(UIColor.blue.cgColor)
        let coordinateX = Constants.findMyLocationCoordinate[i!][0] / Constants.distanceUnit + 0.5
        let coordinateY = Constants.findMyLocationCoordinate[i!][1] / Constants.distanceUnit + 0.5
        context.addEllipse(in: CGRect(x: coordinateX * ratio, y: coordinateY * ratio, width: ratio, height: ratio))

        context.drawPath(using: .fillStroke)
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    func drawPointOnFloorPlan(startingImage: UIImage, x: Int, y: Int, color: CGColor) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color)

        context.addEllipse(in: CGRect(x: x-3, y: y-3, width: 6, height: 6))
        context.drawPath(using: .fillStroke)

        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    func drawFloorPlanPathLocation(startingImage: UIImage, path: [Int]) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        

        var startPoint = CGPoint(x:0,y:0)
        var endPoint = CGPoint(x:0,y:0)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        
        startPoint = CGPoint(x: SearchPath.coordinates[path[0]-1][0], y: SearchPath.coordinates[path[0]-1][1])
  
        context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        
        for i in 1..<path.count{
            endPoint = CGPoint(x: SearchPath.coordinates[path[i]-1][0], y: SearchPath.coordinates[path[i]-1][1])
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            
            
        }
        context.strokePath()
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        newImage = drawPointOnFloorPlan(startingImage: newImage!, x: Int(startPoint.x), y: Int(startPoint.y), color: UIColor.blue.cgColor)
        newImage = drawPointOnFloorPlan(startingImage: newImage!, x: Int(endPoint.x), y: Int(endPoint.y), color: UIColor.red.cgColor)
        
        // Return modified image
        return newImage!
    }
}
