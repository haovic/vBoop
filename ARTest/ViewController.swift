////
////  ViewController.swift
////  ARTest
////
////  Created by Victor Hao on 6/1/18.
////  Copyright © 2018 Victor Hao. All rights reserved.
//
//
import UIKit
import SceneKit
import ARKit
//
class ViewController: UIViewController, ARSCNViewDelegate {
//
    @IBOutlet var sceneView: ARSCNView!
//
//    var ball = SCNNode()
    var box = SCNNode()
//
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

        //Create actions to delay scene setup for 1.5 seconds
        let wait:SCNAction = SCNAction.wait(duration: 1.5)
        let runAfter:SCNAction = SCNAction.run { _ in
            self.setupScene(scene: scene)
        }
        let sequence:SCNAction = SCNAction.sequence([wait, runAfter])
        sceneView.scene.rootNode.runAction(sequence)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]

        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
//
//    // MARK: Actions
//
//    //single tap on ball = bounce up
//    @objc func handleTap(sender: UITapGestureRecognizer) {
//
//        // guard let sceneView = sender.view as? ARSCNView else { return }
//
//        //Get CGPoint of tap and check hit
//        let touchLocation = sender.location(in: sceneView)
//        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
//
//        if !hitTestResult.isEmpty {
//            for hitResult in hitTestResult {
//
//                if (hitResult.node == ball) {
//
//                    ball.physicsBody?.applyForce(SCNVector3(0,10,0), asImpulse: true)
//
//                } else if (hitResult.node == box){
//                    print("box")
//                }
//            }
//        }
//
//    }
//
//    //twof tap = addBall()
//    @objc func handleTwoFTap(sender: UITapGestureRecognizer) {
//        addBall()
//    }
//    //shoots a ball forward from the current location of phone
//    func addBall() {
//
//        guard let pointOfView = self.sceneView.pointOfView else { return }
//
//        //get complete pos data and store in mat
//        let transform:SCNMatrix4 = pointOfView.transform
//        //decompose pos data from mat
//        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
//        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
//        //combine pos data
//        let position = SCNVector3(location.x + orientation.x, location.y + orientation.y, location.z + orientation.z)
//
//        //ball characteristics
//        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
//        ball.position = position
//        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
//        ball.name = "shot_ball"
//        //shoot ball forward
//        ball.physicsBody?.applyForce(SCNVector3(orientation.x * 2, orientation.y * 2, orientation.z * 2), asImpulse: true)
//        self.sceneView.scene.rootNode.addChildNode(ball)
//
//    }
//
    func setupScene(scene: SCNScene) {

        //create origin node
        let dummyNode = scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        dummyNode?.position = SCNVector3(0, -5, -5)

//        //gestures
//        //deafult 1f tap 1 time
//        let ballBounceRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleTap(sender:))))
//
//        let ballShootRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleTwoFTap(sender:))))
//        ballShootRecognizer.numberOfTouchesRequired = 2
//
//        //addGestureRecognizer must be called from main queue
//        DispatchQueue.main.async {
//            self.sceneView.addGestureRecognizer(ballBounceRecognizer)
//            self.sceneView.addGestureRecognizer(ballShootRecognizer)
//        }

        //add default objects
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in

//        if (node.name == "sphere") {
//            ball = node
//            ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
//                ball.physicsBody?.isAffectedByGravity = true
//                ball.physicsBody?.restitution = 1
//
//        } else {
//            box = node
//            box.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node:box, options: nil))
//            box.physicsBody?.isAffectedByGravity = false
//            box.physicsBody?.restitution = 1
//
//            }
//        }

        //setup lighting
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        scene.rootNode.addChildNode(lightNode)

    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        sceneView.session.pause()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }

//
//    // MARK: - ARSCNViewDelegate
//
///*
    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }
//*/
    
    //SET THE SCENE WITH THE TEXT
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
//        guard let hitFeature = results.last else { return }
//        let hitTransform = SCNMatrix4.init(hitFeature.worldTransform)
//        // <- if higher than beta 1, use just this -> hitFeature.worldTransform
//        let hitPosition = SCNVector3Make(hitTransform.m41,
//                                         hitTransform.m42,
//                                         hitTransform.m43)
//        createPicture(hitPosition: hitPosition)
//    }
//    func createPicture(hitPosition : SCNVector3) {
//        let newPicture = SCNText(string: "hello", extrusionDepth: 1)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.green
//        newPicture.materials = [material]
//        let newPictureNode = SCNNode()
//        newPictureNode.position = hitPosition
//        self.sceneView.scene.rootNode.addChildNode(newPictureNode)
//        //  var imageMaterial = SCNMaterial()
//        //   imageMaterial.isDoubleSided = false
//        //    imageMaterial.diffuse.contents = UIImage(named: "vBoop Logo")
//        //  newPicture.materials = [imageMaterial]
//    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
//
//
//
//    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
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


}
