//
//  ViewController.swift
//  Lab9
//
//  Created by Jennifer on 2020-03-18.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    let scene = SCNScene(named: "ics069.scnassets/ics069Scene.scn")!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    
    @IBOutlet weak var changeX: UISlider!
    @IBOutlet weak var changeY: UISlider!
    @IBOutlet weak var changeZ: UISlider!
    
    //    @IBAction func changeX(_ sender: UISlider) {
//        let x = sender.value
//        xLabel.text = String(format: "%.2f", x)
//    }
//
//    @IBAction func changeY(_ sender: UISlider) {
//        let y = sender.value
//        yLabel.text = String(format: "%.2f", y)
//    }
//
//    @IBAction func changeZ(_ sender: UISlider) {
//        let z = sender.value
//        zLabel.text = String(format: "%.2f", z)
//    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        var x : Float = 0
        var y : Float = 0
        var z : Float = 0
        if sender == changeX {
             x = changeX.value
            xLabel.text = String(format: "%.2f", x)
        }
        
        if sender == changeY {
             y = changeY.value
            yLabel.text = String(format: "%.2f", y)
        }
        
        if sender == changeZ {
             z = changeZ.value
            zLabel.text = String(format: "%.2f", z)
        }
        
        if let box = scene.rootNode.childNode(withName: "box", recursively: false) {
            box.position = SCNVector3Make(x,y,z)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        if !ARWorldTrackingConfiguration.isSupported {
            statusLabel.text = "World Tracking not supported"
        }
        else {
            statusLabel.text = "Ready"
            let config = ARWorldTrackingConfiguration()
            config.worldAlignment = .gravity
            config.providesAudioData = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
        statusLabel.text = "session started"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        statusLabel.text = "session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        statusLabel.text = "session's interrupted has ended"
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState.self {
        case .notAvailable:
            statusLabel.text = "TRACKING UNAVAILABLE"
        case .normal:
            statusLabel.text =  "TRACKING NORMAL"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                statusLabel.text = "TRACKING LIMITED Too much camera movement"
            case .insufficientFeatures:
                statusLabel.text = "TRACKING LIMITED Not enough surface detail"
            case .initializing:
                statusLabel.text = "TRACKING LIMITED Initialization in progress."
            case .relocalizing:
                statusLabel.text = "TRACKING LIMITED Relocalization in progress."
            @unknown default:
                fatalError()
            }
        }
    }
}
