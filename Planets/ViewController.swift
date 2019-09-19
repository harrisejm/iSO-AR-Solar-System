//
//  ViewController.swift
//  Planets
//
//  Created by Eddie Harris on 9/17/19.
//  Copyright © 2019 Eddie Harris. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    let configuration = ARWorldTrackingConfiguration()

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view.
    }
    
    func planetTemplate(_ radiusTemplate: CGFloat, _ diffuseTemplate: String, _ specularTemplate: String?, _ emissionTemplate: String?, _ normalTemplate: String?, _ distanceTemplate: Double, _ durationTemplate: TimeInterval) {
        
        let node = SCNNode()
        node.position = SCNVector3(0,0.5,-2)
        self.sceneView.scene.rootNode.addChildNode(node)
        
        let planetNode = planet(geometry: SCNSphere(radius: radiusTemplate), diffuse: diffuseTemplate, specular: specularTemplate, emission: emissionTemplate, normal: normalTemplate, position: SCNVector3(distanceTemplate,0,0))

        rotatePlanet(node,planetNode,durationTemplate)
        planetPath(distanceTemplate)  //path rings
        attachMoonToEarth(diffuseTemplate,planetNode)
    }
    
    func rotatePlanet(_ node: SCNNode, _ planetNode: SCNNode, _ durationTemplate: TimeInterval){
        node.addChildNode(planetNode)
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: durationTemplate)
        let forever = SCNAction.repeatForever(action)
        node.runAction(forever)
    }
    
    //path rings
    func planetPath(_ radius: Double){
        let node = SCNNode()
        node.geometry = SCNTorus(ringRadius: CGFloat(radius), pipeRadius: 0.0005)
        node.position = SCNVector3(0,0.5,-2)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func attachMoonToEarth(_ planet: String, _ node: SCNNode) {
        if planet == "earth day" {
            node.addChildNode(moon())
            let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
            let forever = SCNAction.repeatForever(action)
            node.runAction(forever)
        }
    }
    
    func mercury(){
        planetTemplate(0.04, "mercury", nil, nil, nil, 0.5, 3)
    }
    
    func venus(){
        planetTemplate(0.07, "venus surface", nil, "venus atmosphere", nil, 0.8, 5)
    }
    
    func earth(){
         planetTemplate(0.15, "earth day", "earth specular", "earth clouds", "earth normal", 1.4, 8)
    }
    
    func moon() -> SCNNode {
         let moon = planet(geometry: SCNSphere(radius: 0.04), diffuse: "moon", specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,0.3))
        return moon
    }
    
    func mars(){
        planetTemplate(0.12, "mars", nil, nil, nil, 2, 13)
    }
    
    func jupiter(){
        planetTemplate(0.20, "jupiter", nil, nil, nil, 3, 15)
    }
    
    
    
    
    func sun(){
        let sun = planet(geometry: SCNSphere(radius: 0.35), diffuse: "sun diffuse", specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0.5,-2))
        self.sceneView.scene.rootNode.addChildNode(sun)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        sun()
        mercury()
        venus()
        earth()
        mars()
        jupiter()
    }
    
    func planet(geometry: SCNGeometry, diffuse: String, specular: String?, emission: String?, normal: String?, position: SCNVector3) -> SCNNode {
         let planet = SCNNode(geometry: geometry)
        //diffuse: wraps around the surface
        planet.geometry?.firstMaterial?.diffuse.contents = UIImage(named: diffuse)
        //specular: wraps around node and comtrols how light is reflected
        planet.geometry?.firstMaterial?.specular.contents = UIImage(named: specular ?? "")
        //emission: adds content to surface
        planet.geometry?.firstMaterial?.emission.contents = UIImage(named: emission ?? "")
        //normal: add 3d details to surface"
        planet.geometry?.firstMaterial?.normal.contents = UIImage(named: normal ?? "")
        
        planet.position = position
        
        return planet
    }
}

extension Int {
    var degreesToRadians: Double {
        return Double(self) * .pi/180
    }
}

