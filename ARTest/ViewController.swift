//
//  ViewController.swift
//  ARTest
//
//  Created by Victor Hao on 6/1/18.
//  Copyright © 2018 Victor Hao. All rights reserved.
//

//import UIKit
//import SceneKit
//import ARKit
//
//class ViewController: UIViewController, ARSCNViewDelegate {
//
//    @IBOutlet var sceneView: ARSCNView!
//
//    var ball = SCNNode()
//    var box = SCNNode()
//
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
//        let scene = SCNScene(named: "art.scnassets/MainScene.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
//
//        //Create actions to delay scene setup for 1.5 seconds
//        let wait:SCNAction = SCNAction.wait(duration: 1.5)
//        let runAfter:SCNAction = SCNAction.run { _ in
//            self.setupScene(scene: scene)
//        }
//        let sequence:SCNAction = SCNAction.sequence([wait, runAfter])
//        sceneView.scene.rootNode.runAction(sequence)
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]
//
//        configuration.planeDetection = .horizontal
//
//        // Run the view's session
//        sceneView.session.run(configuration)
//    }
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
//    func setupScene(scene: SCNScene) {
//
//        //create origin node
//        let dummyNode = scene.rootNode.childNode(withName: "DummyNode", recursively: false)
//        dummyNode?.position = SCNVector3(0, -5, -5)
//
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
//
//        //add default objects
//        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
//
//            if (node.name == "sphere") {
//                ball = node
//                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
//                ball.physicsBody?.isAffectedByGravity = true
//                ball.physicsBody?.restitution = 1
//
//            } else {
//                box = node
//                box.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node:box, options: nil))
//                box.physicsBody?.isAffectedByGravity = false
//                box.physicsBody?.restitution = 1
//
//            }
//        }
//
//        //setup lighting
//        let light = SCNLight()
//        light.type = SCNLight.LightType.omni
//        let lightNode = SCNNode()
//        lightNode.light = light
//        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
//        scene.rootNode.addChildNode(lightNode)
//
//    }
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
//
//    // MARK: - ARSCNViewDelegate
//
///*
//    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }
//*/
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
//}

/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary view controller. The speach-to-text engine is managed an configured here.
 */

import UIKit
import Speech

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var recordButton: UIButton!
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = self.audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "(Go ahead, I'm listening)"
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }
    
}



