//
//  File.swift
//  ARTest
//
//  Functions relating to rendering all different models based on location
//  and position data.
//
//  Created by Victor Hao on 6/2/18.
//  Copyright © 2018 Victor Hao. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ViewController {
    
    //remove objects which fall too far
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if (node.name == "shot_ball") {
                
                if (node.presentation.position.z < -10) {
                    
                    node.removeFromParentNode()
                    print("removed shot_ball")
                    
                }
                
            }
            //otherwise check if object pos is too far from current viewer pos
            
        }
        
    }
    
    
    
}
