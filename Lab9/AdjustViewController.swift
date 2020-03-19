//
//  AdjustViewController.swift
//  Lab9
//
//  Created by Jennifer on 2020-03-18.
//  Copyright © 2020 ics069. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class AdjustViewController : UIViewController {
    
    let scene = SCNScene(named: "ics069.scnassets/ics069Scene.scn")!

    //MARK: Labels
    @IBOutlet weak var angularDampingLabel: UILabel!
    @IBOutlet weak var massXLabel: UILabel!
    @IBOutlet weak var massYLabel: UILabel!
    @IBOutlet weak var massZLabel: UILabel!
    @IBOutlet weak var charge: UILabel!
    @IBOutlet weak var damping: UILabel!
    @IBOutlet weak var friction: UILabel!
    @IBOutlet weak var mass: UILabel!
    @IBOutlet weak var restitution: UILabel!
    @IBOutlet weak var rollingFriction: UILabel!
    
    //MARK: Sliders
    @IBOutlet weak var angDamping: UISlider!
    @IBOutlet weak var massXSlider: UISlider!
    @IBOutlet weak var massYSlider: UISlider!
    @IBOutlet weak var massZSlider: UISlider!
    @IBOutlet weak var chargeSlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var frictionSlider: UISlider!
    @IBOutlet weak var massSlider: UISlider!
    @IBOutlet weak var restitutionSlider: UISlider!
    @IBOutlet weak var rollingFrictionSlider: UISlider!
    
    var physicsBody : SCNPhysicsBody?
    

     
    @IBAction func unwindToDocumentViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController {
            physicsBody = sourceViewController.physicsBody
            
            
//            pickerData = sourceViewController.pickerData
//            pressedButton = sourceViewController.pressedButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        angDamping.value = Float(physicsBody!.angularDamping)
        angularDampingLabel.text = String(format: "%.2f", angDamping.value)

        massXSlider.value = Float(physicsBody!.centerOfMassOffset.x)
        massXLabel.text = String(format: "%.2f", massXSlider.value)

        massYSlider.value = Float(physicsBody!.centerOfMassOffset.y)
        massYLabel.text = String(format: "%.2f", massYSlider.value)

        massZSlider.value = Float(physicsBody!.centerOfMassOffset.z)
        massZLabel.text = String(format: "%.2f", massZSlider.value)

        chargeSlider.value = Float(physicsBody!.charge)
        charge.text = String(format: "%.2f", chargeSlider.value)

        massSlider.value = Float(physicsBody!.mass)
        mass.text = String(format: "%.2f", massSlider.value)
        
        dampingSlider.value = Float(physicsBody!.damping)
        damping.text = String(format: "%.2f", dampingSlider.value)

        frictionSlider.value = Float(physicsBody!.friction)
        friction.text = String(format: "%.2f", frictionSlider.value)

        restitutionSlider.value = Float(physicsBody!.restitution)
        restitution.text = String(format: "%.2f", restitutionSlider.value)

        rollingFrictionSlider.value = Float(physicsBody!.rollingFriction)
        rollingFriction.text = String(format: "%.2f", rollingFrictionSlider.value)
    }
    
    @IBAction func changingValues(_ sender: UISlider) {
        var x : Float = 0
        var y : Float = 0
        var z : Float = 0
        
        if (sender == angDamping) {
            let valAngDamp = angDamping.value
            physicsBody?.angularDamping = CGFloat(valAngDamp)
            angularDampingLabel.text = String(format: "%.2f", valAngDamp)
        }
        
        if (sender == massXSlider) {
            x = massXSlider.value
            physicsBody?.centerOfMassOffset.x = x
            massXLabel.text = String(format: "%.2f", x)
        }

        if (sender == massYSlider) {
            y = massYSlider.value
            physicsBody?.centerOfMassOffset.y = y
            massYLabel.text = String(format: "%.2f", y)
        }

        if (sender == massZSlider) {
            z = massZSlider.value
            physicsBody?.centerOfMassOffset.z = z
            massZLabel.text = String(format: "%.2f", z)
        }
        
        if (sender == chargeSlider) {
            let chargeVal = chargeSlider.value
            physicsBody?.charge = CGFloat(chargeVal)
            charge.text = String(format: "%.2f", chargeVal)

        }
        
        if (sender == dampingSlider) {
            let dampingVal = dampingSlider.value
            physicsBody?.damping = CGFloat(dampingVal)
            damping.text = String(format: "%.2f", dampingVal)
        }
        
        if (sender == frictionSlider) {
            let frictionVal = frictionSlider.value
            physicsBody?.friction = CGFloat(frictionVal)
            friction.text = String(format: "%.2f", frictionVal)
        }
        
        if (sender == massSlider) {
            let massVal = massSlider.value
            physicsBody?.mass = CGFloat(massVal)
            mass.text = String(format: "%.2f", massVal)
        }
        
        if (sender == restitutionSlider) {
            let resVal = restitutionSlider.value
            physicsBody?.restitution = CGFloat(resVal)
            restitution.text = String(format: "%.2f", resVal)
        }
        
        if (sender == rollingFrictionSlider) {
            let rollFrictVal = rollingFrictionSlider.value
            physicsBody?.rollingFriction = CGFloat(rollFrictVal)
            rollingFriction.text = String(format: "%.2f", rollFrictVal)
        }
        
        if let box = scene.rootNode.childNode(withName: "box", recursively: false) {
            box.position = SCNVector3Make(x,y,z)
        }
    }
    
}
