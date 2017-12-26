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
//        var uUint = Constants.u / Constants.distanceUnit
//        var vUint = Constants.v / Constants.distanceUnit

        let ratio :Double = Double(startingImage.size.width / 10)
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAlpha(0.5)
        //context.setLineWidth(1.0)
        var findMyLocationCoordinate = [[Constants.u/2, 0.0], [0.0,Constants.v/2], [Constants.u/2,Constants.v], [Constants.u,Constants.v/2]]
        
        for i in 0..<4{
            context.setFillColor(Constants.beaconsInfo.color[i])
            let coordinateX = findMyLocationCoordinate[i][0] / Constants.distanceUnit - 0.25 + (10 - Constants.u / Constants.distanceUnit)/2
            let coordinateY = findMyLocationCoordinate[i][1] / Constants.distanceUnit - 0.25 + (10 - Constants.v / Constants.distanceUnit)/2

            context.addEllipse(in: CGRect(x: coordinateX * ratio, y: coordinateY * ratio, width: ratio/2, height: ratio/2))
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
        
        let myLocationX = x / Constants.distanceUnit - 0.25 + (10 -  Constants.u / Constants.distanceUnit)/2
        let myLocationY = y / Constants.distanceUnit - 0.25 + (10 -  Constants.v / Constants.distanceUnit)/2
 
        context.setFillColor(UIColor.blue.cgColor)
        context.addEllipse(in: CGRect(x: myLocationX * ratio, y: myLocationY * ratio, width: ratio/2, height: ratio/2))
        context.drawPath(using: .fillStroke)
        

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    
//    func drawMyLocationImmediate(startingImage: UIImage, minor: Int) -> UIImage {
//        UIGraphicsBeginImageContext(startingImage.size)
//        
//        // Draw the starting image in the current context as background
//        startingImage.draw(at: CGPoint.zero)
//        let ratio :Double = Double(startingImage.size.width / 10)
//        
//        // Get the current context
//        let context = UIGraphicsGetCurrentContext()!
//        
//        context.setAlpha(0.5)
//        
//        let i = Constants.beaconsInfo.minor.index(of: minor)
//        context.setFillColor(UIColor.blue.cgColor)
//        
//        var findMyLocationCoordinate = [[Constants.u/2, 0.0], [0.0,Constants.v/2], [Constants.u/2,Constants.v], [Constants.u,Constants.v/2]]
//        
//        let coordinateX = findMyLocationCoordinate[i!][0] / Constants.distanceUnit + 0.5
//        let coordinateY = findMyLocationCoordinate[i!][1] / Constants.distanceUnit + 0.5
//        context.addEllipse(in: CGRect(x: coordinateX * ratio, y: coordinateY * ratio, width: ratio, height: ratio))
//
//        context.drawPath(using: .fillStroke)
//        
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        // Return modified image
//        return newImage!
//    }
    
    func drawPointOnFloorPlan(startingImage: UIImage, x: Int, y: Int, color: CGColor) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        //print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color)

        context.addEllipse(in: CGRect(x: x-10, y: y-10, width: 20, height: 20))
        context.drawPath(using: .fillStroke)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    func drawFloorPlanPathLocation(startingImage: UIImage, path: [Int]) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        //print("width \(startingImage.size.width)   height \(startingImage.size.height)")
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(5.0)
        context.setStrokeColor(UIColor.red.cgColor)
        

        
        let startPoint = CGPoint(x: SearchPath.coordinates[path[0]-1][0], y: SearchPath.coordinates[path[0]-1][1])
        var endPoint = startPoint
        
        context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        
        for i in 1..<path.count{
            endPoint = CGPoint(x: SearchPath.coordinates[path[i]-1][0], y: SearchPath.coordinates[path[i]-1][1])
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            
            
        }
        context.strokePath()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        

        // Return modified image
        return newImage!
    }
    func drawLiftPointFloorPlan(floorPlanImages: [UIImage], startNode: Int, endNode: Int) -> [UIImage] {
        var tempImages = floorPlanImages
        let startFloor :Int =  Constants.floorPlanIndex.index(of:Int(Constants.storesDB[startNode-1][3])!)!
        let endFloor :Int = Constants.floorPlanIndex.index(of:Int(Constants.storesDB[endNode-1][3])!)!
        
        if startFloor < endFloor{
            tempImages[startFloor] = drawLiftTriangle(startingImage: tempImages[startFloor], x: SearchPath.coordinates[startNode-1][0], y: SearchPath.coordinates[startNode-1][1], up: 1, color: UIColor.black.cgColor)
            tempImages[endFloor] = drawPointOnFloorPlan(startingImage: tempImages[endFloor], x: SearchPath.coordinates[endNode-1][0], y: SearchPath.coordinates[endNode-1][1], color: UIColor.black.cgColor)

        }else{
            tempImages[startFloor] = drawLiftTriangle(startingImage: tempImages[startFloor], x: SearchPath.coordinates[startNode-1][0], y: SearchPath.coordinates[startNode-1][1], up: -1,  color: UIColor.purple.cgColor)
            tempImages[endFloor] = drawPointOnFloorPlan(startingImage: tempImages[endFloor], x: SearchPath.coordinates[endNode-1][0], y: SearchPath.coordinates[endNode-1][1], color: UIColor.purple.cgColor)
        }
       
        // Return modified image
        return tempImages
    }
    func drawLiftTriangle(startingImage: UIImage, x: Int, y:Int, up: Int, color:CGColor) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)

        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()!
        //context.setLineWidth(5.0)
       
        context.beginPath()
        context.move(to: CGPoint(x: x , y: y - 20 * up))
        context.addLine(to: CGPoint(x: x - 10, y: y))
        context.addLine(to: CGPoint(x: x + 10, y: y))
        context.closePath()
        
 
            context.setFillColor(color)
    
        context.fillPath()
        
        //context.strokePath()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // Return modified image
        return newImage!
    }
    
    func drawFlanSeatPath(startingImage: UIImage, startX: Double,startY: Double, stopX: Double,stopY: Double) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        //print("width \(startingImage.size.width)   height \(startingImage.size.height)")
         Constants.findSeatUnitSize / Constants.findSeatFloorPlanUnit[1]
        //print("width \(startingImage.size.width)   height \(startingImage.size.height) unit \(widthUnit, heightUnit)")
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(10.0)
        context.setStrokeColor(UIColor.red.cgColor)
        
        
        context.move(to: CGPoint(x: startX * Constants.widthUnit, y: startY * Constants.heightUnit))
        context.addLine(to: CGPoint(x: stopX * Constants.widthUnit, y:stopY * Constants.heightUnit))

        context.strokePath()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // Return modified image
        return newImage!
    }
    
    func drawFlanSeatCurrentPoint(startingImage: UIImage, x: Double, y: Double) -> UIImage {
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)

        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.green.cgColor)
        
        context.addEllipse(in: CGRect(x: (x * Constants.widthUnit) - 10, y: (y * Constants.heightUnit) - 10 , width: 20, height: 20))
        context.drawPath(using: .fillStroke)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return newImage!
    }
    
    
    
    
}
