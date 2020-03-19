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

    var firstPlane = true
    var scene = SCNScene(named: "ics069.scnassets/ics069Scene.scn")!
    var physicsBody : SCNPhysicsBody?
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    var config = ARWorldTrackingConfiguration()

    @IBOutlet weak var changeX: UISlider!
    @IBOutlet weak var changeY: UISlider!
    @IBOutlet weak var changeZ: UISlider!
    
    
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
        scene = SCNScene()
        
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody?.isAffectedByGravity = true
        physicsBody?.allowsResting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        if !ARWorldTrackingConfiguration.isSupported {
            statusLabel.text = "World Tracking not supported"
        }
        else {
            statusLabel.text = "Ready"
            config.worldAlignment = .gravity
            config.providesAudioData = false
            config.planeDetection = .horizontal
        }
    }
    @IBAction func launch(_ sender: Any) {
        guard let frame = self.sceneView.session.currentFrame else {
            return
        }
        let transform = SCNMatrix4(frame.camera.transform)
        let position = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        let boxScene = SCNScene(named: "ics069.scnassets/ics069Scene.scn")
        
        guard let box = boxScene?.rootNode.childNode(withName: "box", recursively: false) else {
            return
        }
        
        let newPhysicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        newPhysicsBody.isAffectedByGravity = self.physicsBody!.isAffectedByGravity
        newPhysicsBody.allowsResting = self.physicsBody!.allowsResting
        newPhysicsBody.angularDamping = self.physicsBody!.angularDamping
        newPhysicsBody.centerOfMassOffset = self.physicsBody!.centerOfMassOffset
        newPhysicsBody.charge = self.physicsBody!.charge
        newPhysicsBody.damping = self.physicsBody!.mass
        newPhysicsBody.friction = self.physicsBody!.friction
        newPhysicsBody.mass = self.physicsBody!.mass
        newPhysicsBody.restitution = self.physicsBody!.restitution
        newPhysicsBody.rollingFriction = self.physicsBody!.rollingFriction
        
        let newBox = box.clone()
        newBox.physicsBody = newPhysicsBody
        newBox.position = position
        self.sceneView.scene.rootNode.addChildNode(newBox)
        
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            for node in self.sceneView.scene.rootNode.childNodes {
                if (node.name == "box" && node.presentation.position.y < -10) {
                    node.removeFromParentNode()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let config = ARWorldTrackingConfiguration()
        

//        let config = ARWorldTrackingConfiguration()
//            config.worldAlignment = .gravity
//            config.providesAudioData = false
//            config.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if (firstPlane) {
            firstPlane = false
        }
        else {
            return
        }
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        DispatchQueue.main.async {
            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let planeNode = SCNNode(geometry: planeGeometry)
            
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
            planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
            planeNode.physicsBody?.restitution = 0.5
            planeNode.physicsBody?.friction = 0.5
            node.addChildNode(planeNode)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, node.childNodes.count > 0, let planeGeometry = node.childNodes[0].geometry as? SCNPlane else {
            return
        }
        
        DispatchQueue.main.async {
            planeGeometry.width = CGFloat(planeAnchor.extent.x)
            planeGeometry.height = CGFloat(planeAnchor.extent.z)
            node.childNodes[0].position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    @IBAction func unwindToDocumentViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AdjustViewController {
            physicsBody = sourceViewController.physicsBody
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier != "ShowController" {
            return
        }
        guard let adjustViewController = segue.destination.children[0] as? AdjustViewController else {
            fatalError("Unexpected destination \(segue.destination)")
        }
        adjustViewController.physicsBody = physicsBody
//        customizeViewController.pickerData = pickerData
//        customizeViewController.pressedButton = pressedButton
    }
    
    
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
