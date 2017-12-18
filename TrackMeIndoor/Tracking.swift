//
//  Tracking.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 18/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import Foundation
import CoreMotion

class Tracking {
    let MotionManager = CMMotionManager()
    let update_freq = 0.02;
    let high_pass_filter = 0.2;
    let high_pass_filter2 = 0.4;
    let low_pass_filter = 1.5;
    
    var preTime: Double = 0;
    var currentTime: Double = 0;
    var pre_z_a: Double = 0;
    var a_z_counter: Int = 0;
    
    var rotational_matrix: matrix = arange(9).reshape((3,3));
    var acceleration_matrix: matrix = arange(3).reshape((3,1));
    
    var x: Double = 0; // roll
    var y: Double = 0; // pitch
    var z: Double = 0; // yaw
    
    
    var acceleration_x: Double = 0;
    var acceleration_y: Double = 0;
    var acceleration_z: Double = 0;
    
    var velocity_x: Double = 0;
    var velocity_y: Double = 0;
    var velocity_z: Double = 0;
    
    var position_x: Double = 0;
    var position_y: Double = 0;
    var position_z: Double = 0;
    
    var ax: Double = 0;
    var qx: Double = 0.0000787279;
    var rx: Double = 0.00076041;
    var px: Double = 1;
    var kx: Double = 0.5;
    
    var ay: Double = 0;
    var qy: Double = 0.00007608031;
    var ry: Double = 0.00097525;
    var py: Double = 1;
    var ky: Double = 0.5;
    
    var az: Double = 0;
    var qz: Double = 0.000145;
    var rz: Double = 0.001546128;
    var pz: Double = 1;
    var kz: Double = 0.5;
    
    /*  Office Calibration Data
     var ax: Double = 0;
     var qx: Double = 0.00008546501;
     var rx: Double = 0.0553829;
     var px: Double = 1;
     var kx: Double = 0.5;
     
     var ay: Double = 0;
     var qy: Double = 0.00008288768;
     var ry: Double = 0.00533873;
     var py: Double = 1;
     var ky: Double = 0.5;
     
     var az: Double = 0;
     var qz: Double = 0.00014201;
     var rz: Double = 0.0099572;
     var pz: Double = 1;
     var kz: Double = 0.5;
     */
    init(){
        MotionManager.deviceMotionUpdateInterval = 0.005;
        MotionManager.startMagnetometerUpdates();
        MotionManager.startGyroUpdates();
        MotionManager.startAccelerometerUpdates();
        MotionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXMagneticNorthZVertical);
    }
    
    func update(){
        update_euler();
        update_acceleration();
        update_volocity();
        update_position();
        print("update");
    }
    func update_euler(){
        var quat:CMQuaternion  = MotionManager.deviceMotion!.attitude.quaternion;
        x = atan2(2*(quat.y*quat.z - quat.w*quat.x), 2*(quat.w*quat.w) - 1 + 2*(quat.z*quat.z));
        var temp: Double = (2*quat.x*quat.z+2*quat.w*quat.y);
        y = -atan(2*(quat.x*quat.z - quat.w*quat.y)/(sqrt(1-temp*temp)));
        z = atan2(2*(quat.x*quat.y - quat.w*quat.z) , 2*(quat.w*quat.w) - 1 + 2*(quat.x*quat.x));
    }
    func update_acceleration(){
        
        pre_z_a = acceleration_matrix.flat[2];
        
        acceleration_x = (MotionManager.deviceMotion?.userAcceleration.x)!*9.81;
        acceleration_y = (MotionManager.deviceMotion?.userAcceleration.y)!*9.81;
        acceleration_z = (MotionManager.deviceMotion?.userAcceleration.z)!*9.81;
        
        px = px + qx;
        kx = px/(px+rx);
        ax = ax + kx*(acceleration_x-ax);
        px = (1-kx)*px;
        
        py = py + qy;
        ky = py/(py+ry);
        ay = ay + ky*(acceleration_y-ay);
        py = (1-ky)*py;
        
        pz = pz + qz;
        kz = pz/(pz+rz);
        az = az + kz*(acceleration_z-az+0.0422217);
        pz = (1-kz)*pz;
        
        acceleration_matrix = Array(ax, ay, az).reshape((3,1));
        
        // Rotate to global coordinate
        rotational_matrix = Array(1, 0 , 0, 0, cos(y), -sin(y), 0, sin(y), cos(y)).reshape((3,3));
        acceleration_matrix = rotational_matrix.dot(acceleration_matrix);
        rotational_matrix = Array(cos(x),0,sin(x),0,1,0,-sin(x),0,cos(x)).reshape((3,3));
        acceleration_matrix = rotational_matrix.dot(acceleration_matrix);
        rotational_matrix = Array(cos(z),-sin(z),0,sin(z),cos(z),0,0,0,1).reshape((3,3));
        acceleration_matrix = rotational_matrix.dot(acceleration_matrix);
        
        // High Pass Filter
        if(acceleration_matrix.flat[0] <= high_pass_filter && acceleration_matrix.flat[0] >= -high_pass_filter){
            acceleration_matrix.flat[0] = 0;
        }
        if(acceleration_matrix.flat[1] <= high_pass_filter && acceleration_matrix.flat[1] >= -high_pass_filter){
            acceleration_matrix.flat[1] = 0;
        }
        if(acceleration_matrix.flat[2] <= high_pass_filter2 && acceleration_matrix.flat[2] >= -high_pass_filter2){
            acceleration_matrix.flat[2] = 0;
        }
        
        // Low Pass Filter
        if(acceleration_matrix.flat[0] >= low_pass_filter || acceleration_matrix.flat[0] <= -low_pass_filter){
            acceleration_matrix.flat[0] = low_pass_filter;
        }
        if(acceleration_matrix.flat[1] >= low_pass_filter && acceleration_matrix.flat[1] <= -low_pass_filter){
            acceleration_matrix.flat[1] = low_pass_filter;
        }
        
        
        /*
         px = px + qx;
         kx = px/(px+rx);
         ax = ax + kx*(acceleration_matrix.flat[0]-ax);
         px = (1-kx)*px;
         
         py = py + qy;
         ky = py/(py+ry);
         ay = ay + ky*(acceleration_matrix.flat[1]-ay);
         py = (1-ky)*py;
         
         pz = pz + qz;
         kz = pz/(pz+rz);
         az = az + kz*(acceleration_matrix.flat[2]-az+0.0405718);
         pz = (1-kz)*pz;
         */
        print("\(acceleration_matrix.flat[0]) \(acceleration_matrix.flat[1]) \(acceleration_matrix.flat[2]) ");
    }
    func update_volocity(){
        velocity_x = velocity_x + acceleration_matrix.flat[0]*update_freq;
        velocity_y = velocity_y - acceleration_matrix.flat[1]*update_freq;
        velocity_z = velocity_z + acceleration_matrix.flat[2]*update_freq;
        
        if(acceleration_matrix.flat[2] < pre_z_a){
            velocity_x = 0;
            velocity_y = 0;
            velocity_z = 0;
        }
        if(acceleration_matrix.flat[2] == 0){
            a_z_counter = a_z_counter + 1;
            if(a_z_counter > 10){
                velocity_x = 0;
                velocity_y = 0;
                velocity_z = 0;
            }
        }else{
            a_z_counter = 0;
        }
        
        print("\(velocity_x) \(velocity_y) \(velocity_z) ");
        
    }
    func update_position(){
        position_x = position_x + velocity_x*update_freq;
        position_y = position_y + velocity_y*update_freq;
        position_z = position_z + velocity_z*update_freq;
        
        print("\(position_x) \(position_y) \(position_z)");
    }
}
