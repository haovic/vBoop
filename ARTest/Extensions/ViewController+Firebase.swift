//
//  ViewController+Firebase.swift
//  ARTest
//
//  Created by Victor Hao on 6/2/18.
//  Copyright © 2018 Victor Hao. All rights reserved.
//

import UIKit
import Firebase
import SceneKit
import ARKit
import CoreLocation


extension ViewController {
    
    func uploadObjectInfo(location: SCNVector3, position: SCNVector4, name: String) {
        
        let ref: DatabaseReference! = Database.database().reference()
        
        // get a unique string for the object
        let objName = NSUUID().uuidString
        
        // upload pos and loc info
        let locArr:NSArray = [location.x, location.y, location.z]
        let posArr:NSArray = [position.x, position.y, position.z, position.w]
        let values = ["locArr": locArr, "posArr": posArr, "modelName": name] as [String : Any]
        
        print("attempted?")
        let storageRef = ref.child("loc_pos").child(objName)
        storageRef.updateChildValues(values)
        
        // upload gps info
        let gps = ["latitude": currentLocation!.coordinate.latitude, "longitude": currentLocation!.coordinate.longitude, "heading": currentHeading!.trueHeading] as [String : Any]
        let storageRef2 = ref.child("gps").child(objName)
        storageRef2.updateChildValues(gps)
        print("attempted2?")
        
    }
    
    func getNearbyObjectInfo() {
        
        let ref: DatabaseReference! = Database.database().reference()
        
        let refHandle = ref.child("loc_pos").observe(DataEventType.value, with: {(snapshot) in
            guard let locpos = snapshot.value as? [String: NSArray] else { return }
            
            let refHandle2 = ref.child("gps").observe(DataEventType.value, with: {(snapshot) in
                
                
                guard let gps = snapshot.value as? [String: AnyObject] else { return }
                let objgps = CLLocation(latitude: gps["latitude"] as! CLLocationDegrees, longitude: gps["longitude"] as! CLLocationDegrees)
                
                // check if the current obj is within 30m
                let distance = objgps.distance(from: self.currentLocation!)
                if  distance < 30 {
                    
                    // create scnvecs with cloud data
                    let locVec = SCNVector3Make(locpos["locArr"]![0] as! Float, locpos["locArr"]![1] as! Float, locpos["locArr"]![2] as! Float)

                    let posVec = SCNVector4Make(locpos["posArr"]![0] as! Float, locpos["posArr"]![1] as! Float, locpos["posArr"]![2] as! Float, locpos["posArr"]![3] as! Float)
                    
                    let name = locpos["name"]![0]
                    
                    // under construction
                    //self.renderServer(locVector: locVec, posVector: posVec, modelname: name as! String)
                }
                
            })
        })
        
    }
    
    func renderServer(locVector: SCNVector3, posVector: SCNVector4, modelname: String) {
        
        guard let pointOfView = self.sceneView.pointOfView else { return }
        
        //get complete pos data and store in mat
        let transform:SCNMatrix4 = pointOfView.transform
        //decompose pos data from mat
        let location = SCNVector3(transform.m41, transform.m42, transform.m43) + locVector
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        //combine pos data
        let position = SCNVector3(location.x + orientation.x, location.y + orientation.y, location.z + orientation.z)
        
        let obj = SCNScene(named: "art.sncassets/\(modelname).dae")
        
    }
    
}
