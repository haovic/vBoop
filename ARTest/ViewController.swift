//
//  ViewController.swift
//  ARTest
//
//  Created by Victor Hao on 6/1/18.
//  Copyright © 2018 Victor Hao. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation
import Firebase

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: Properties
    
    var ball = SCNNode()
    var box = SCNNode()
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    var sceneLocationView = SceneLocationView()
    let locationManager = CLLocationManager()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Create actions to delay scene setup for 1.5 seconds
        let wait:SCNAction = SCNAction.wait(duration: 1.5)
        let runAfter:SCNAction = SCNAction.run { _ in
            self.setupScene(scene: scene)
        }
        let sequence:SCNAction = SCNAction.sequence([wait, runAfter])
        sceneView.scene.rootNode.runAction(sequence)
        
        // Run the location scene when it comes into view
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        // Start getting locations
        startReceivingLocationChanges()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        // Run the location scene when it comes into view
        sceneLocationView.run()
        // Start getting locations again
        startReceivingLocationChanges()
    }
    
    // MARK: Actions
    
    //single tap on ball = bounce up
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // guard let sceneView = sender.view as? ARSCNView else { return }
        
        //Get CGPoint of tap and check hit
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitTestResult.isEmpty {
            for hitResult in hitTestResult {
                
                if (hitResult.node == ball) {
                    
                    ball.physicsBody?.applyForce(SCNVector3(0,10,0), asImpulse: true)
                    
                } else if (hitResult.node == box){
                    print("box")
                }
            }
        }
        
    }
    
    //twof tap = addBall()
    @objc func handleTwoFTap(sender: UITapGestureRecognizer) {
        addBall()
    }
    //shoots a ball forward from the current location of phone
    func addBall() {
        
        guard let pointOfView = self.sceneView.pointOfView else { return }
        
        //get complete pos data and store in mat
        let transform:SCNMatrix4 = pointOfView.transform
        //decompose pos data from mat
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        //combine pos data
        let position = SCNVector3(location.x + orientation.x, location.y + orientation.y, location.z + orientation.z)
        
        //ball characteristics
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.position = position
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
        ball.name = "shot_ball"
        //shoot ball forward
        ball.physicsBody?.applyForce(SCNVector3(orientation.x * 2, orientation.y * 2, orientation.z * 2), asImpulse: true)
        self.sceneView.scene.rootNode.addChildNode(ball)
        
    }
    
    func setupScene(scene: SCNScene) {
        
        //create origin node
        let dummyNode = scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        dummyNode?.position = SCNVector3(0, -5, -5)
        
        //gestures
        //deafult 1f tap 1 time
        let ballBounceRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleTap(sender:))))
        
        let ballShootRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleTwoFTap(sender:))))
        ballShootRecognizer.numberOfTouchesRequired = 2
        
        //addGestureRecognizer must be called from main queue
        DispatchQueue.main.async {
            self.sceneView.addGestureRecognizer(ballBounceRecognizer)
            self.sceneView.addGestureRecognizer(ballShootRecognizer)
        }
        
        //add default objects
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            
            if (node.name == "sphere") {
                ball = node
                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
                ball.physicsBody?.isAffectedByGravity = true
                ball.physicsBody?.restitution = 1
                
            } else {
                box = node
                box.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node:box, options: nil))
                box.physicsBody?.isAffectedByGravity = false
                box.physicsBody?.restitution = 1
                
            }
        }
        
        //setup lighting
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        scene.rootNode.addChildNode(lightNode)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        // Pause the scenelocationview
        sceneLocationView.pause()
        
        // Stop getting locations
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
