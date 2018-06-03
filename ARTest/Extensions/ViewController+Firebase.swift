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
        let gps = ["latitude": currentLocation!.coordinate.latitude, "longitude": currentLocation!.coordinate.longitude , "heading": currentHeading!.trueHeading ]
        let storageRef2 = ref.child("gps").child(objName)
        storageRef2.updateChildValues(gps)
        print("attempted2?")
        
    }
    
    func getNearbyObjectInfo() {
        print("first")
        
        let ref: DatabaseReference! = Database.database().reference()
        
        let refHandle = ref.child("loc_pos").observe(DataEventType.value, with: {(snapshot) in
            guard let locpos = snapshot.value as? [String: Any] else { return }
            
            print("second")
            
            let refHandle2 = ref.child("gps").observe(DataEventType.value, with: {(snapshot) in
                
                print("additional debug")
                guard let gps = snapshot.value as? [String: Double] else { return }
                
                let cllLatitude = CLLocationDegrees(exactly: gps["latitude"]!)
                let cllLongitude = CLLocationDegrees(exactly: gps["longitude"]!)
                let objgps = CLLocation(latitude: cllLatitude!, longitude: cllLongitude!)
                
                print("up here")
                
                // check if the current obj is within 30m
                let distance = objgps.distance(from: self.currentLocation!)
                if  distance < 100 {
                    
                    // create scnvecs with cloud data
                    guard let locpos1 = locpos["locArr"] as? NSArray else { return }
                    guard let locpos2 = locpos["posArr"] as? NSArray else { return }
                    
                    let locVec = SCNVector3Make(locpos1[0] as! Float, locpos1[1] as! Float, locpos1[2] as! Float)

                    let posVec = SCNVector4Make(locpos2[0] as! Float, locpos2[1] as! Float, locpos2[2] as! Float, locpos2[3] as! Float)
                    
                    guard let name = locpos["name"] as? NSString else { return }
                    
                    print("we made it here")
                    
                    // under construction
                    self.renderServer(locVector: locVec, posVector: posVec, modelname: name as String)
                }
                
            })
        })
        
    }
    
    func renderServer(locVector: SCNVector3, posVector: SCNVector4, modelname: String) {
        
        print("rendering from server")
        
        guard let pointOfView = self.sceneView.pointOfView else { return }
        
        //get complete pos data and store in mat
        let transform:SCNMatrix4 = pointOfView.transform
        //decompose pos data from mat
        let location = SCNVector3(transform.m41, transform.m42, transform.m43) + locVector
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        //combine pos data
        let position = SCNVector3(location.x + orientation.x, location.y + orientation.y, location.z + orientation.z)
        
        guard let obj = SCNScene(named: "art.sncassets/\(modelname)/\(modelname).scn") else { return }
        let obj_child_nodes = obj.rootNode.childNodes
        let obj_node = SCNNode()
        obj_node.position = position
        
        DispatchQueue.main.async {
            for node in obj_child_nodes {
                obj_node.addChildNode(node)
            }
        }
        
    }
    
}
