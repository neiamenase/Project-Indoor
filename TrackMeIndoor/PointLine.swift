//
//  PointLine.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit

class PointLine {
    
    
    var BGView:UIView = UIView(frame: CGRect(x:0, y:0, width:320, height:320))
    
    var lastPoint:CGPoint = CGPoint()
    var pointsCount = 0
    
    var LinesView:UIView
    init(){
        LinesView = UIView(frame: CGRect(x:BGView.frame.minX + 10, y:BGView.frame.minY + 10, width:BGView.frame.maxX - 10, height:BGView.frame.maxY - 10))
        //
        //        BGView.addSubview(LinesView)
    }
    
    init(superView:UIView){
        BGView = superView
        LinesView = UIView(frame: CGRect(x:BGView.frame.minX + 10, y:BGView.frame.minY + 10, width:BGView.frame.maxX - 10, height: BGView.frame.maxY - 10))
        //
        //        BGView.addSubview(LinesView)
        
    }
    
    func addLineView(){
        LinesView = UIView(frame: CGRect(x:BGView.frame.minX + 10, y:BGView.frame.minY + 10, width:BGView.frame.maxX - 10, height:BGView.frame.maxY - 10))
        BGView.addSubview(LinesView)
        pointsCount = 0
    }
    
    func drawLineToPoint(point:CGPoint){
        if(pointsCount != 0){
            var polygonShapeLayer:CAShapeLayer = CAShapeLayer()
            polygonShapeLayer.fillColor = UIColor.lightGray.cgColor
            polygonShapeLayer.strokeColor = UIColor.gray.cgColor
            polygonShapeLayer.lineWidth = 2
            var path:UIBezierPath = UIBezierPath()
            path.move(to: lastPoint)
            path.addLine(to: point)
            polygonShapeLayer.path = path.cgPath
            LinesView.layer.addSublayer(polygonShapeLayer)
            LinesView.layer.borderColor = UIColor.black.cgColor
        }
        lastPoint = point
        
        pointsCount = pointsCount + 1
    }
    
    func cleanView(){
        LinesView.removeFromSuperview();
    }
    
}
