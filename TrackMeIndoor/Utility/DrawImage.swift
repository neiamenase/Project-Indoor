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
    
    func drawFloorPlanLocation(startingImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        
        for coordinates in SearchPath.coordinates{
            
            context.addEllipse(in: CGRect(x: coordinates[0]-2, y: coordinates[1]-2, width: 4, height: 4))
            context.drawPath(using: .fillStroke)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    func drawFloorPlanPathLocation(startingImage: UIImage, path: [Int]) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        
        let startPoint = CGPoint(x: SearchPath.coordinates[path[0]-1][0], y: SearchPath.coordinates[path[0]-1][1])
  
        context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        
        for i in 1..<path.count{
            let endPoint = CGPoint(x: SearchPath.coordinates[path[i]-1][0], y: SearchPath.coordinates[path[i]-1][1])
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            
           // print("start:\(path[i])  \(startPoint)  end:\(path[i+1])  \(endPoint)")
            //context.addLines(between: [startPoint,endPoint])
            
        }
        context.strokePath()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
}
