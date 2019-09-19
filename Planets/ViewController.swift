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
    
    var size : Double = 1
    
    @IBAction func changeSizeSmall(_ sender: UIButton) {
        size = 0.7
        print("H")
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            node.removeFromParentNode()
        })
        createPlanets()
    }
    
    @IBAction func changeSizeMedium(_ sender: UIButton) {
        size = 1.0
        print("H")
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            node.removeFromParentNode()
        })
        createPlanets()
    }
    
    @IBAction func changeSizeLarge(_ sender: UIButton) {
        size = 1.5
        print("H")
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            node.removeFromParentNode()
        })
        createPlanets()
    }
    
    
    func planetTemplate(_ radiusTemplate: CGFloat, _ diffuseTemplate: String, _ specularTemplate: String?, _ emissionTemplate: String?, _ normalTemplate: String?, _ distanceTemplate: Double, _ durationTemplate: TimeInterval) {
        
        let node = SCNNode()
        node.position = SCNVector3(0,0.5,-2)
        self.sceneView.scene.rootNode.addChildNode(node)
        
        let planetNode = planet(geometry: SCNSphere(radius: radiusTemplate*CGFloat(size)), diffuse: diffuseTemplate, specular: specularTemplate, emission: emissionTemplate, normal: normalTemplate, position: SCNVector3(distanceTemplate*size,0,0))

        rotatePlanet(node,planetNode,durationTemplate)
        planetPath(distanceTemplate)  //path rings
        attachMoonToEarth(diffuseTemplate,planetNode)
        attachRingToSaturn(diffuseTemplate,planetNode)
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
        node.geometry = SCNTorus(ringRadius: CGFloat(radius*size), pipeRadius: 0.0005)
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
    
    func attachRingToSaturn(_ planet: String, _ node: SCNNode) {
        if planet == "saturn" {
            node.addChildNode(saturnRing())
        }
    }
    
    
    func moon() -> SCNNode {
        let moon = planet(geometry: SCNSphere(radius: CGFloat(0.04*size)), diffuse: "moon", specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,0.25*size))
        return moon
    }
    
    func saturnRing() -> SCNNode {
        let saturn = planet(geometry: SCNTube(innerRadius: CGFloat(0.17*size), outerRadius: CGFloat(0.28*size), height: CGFloat(0.003*size)), diffuse: "saturn ring", specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,0))
        return saturn
    }
    
    func createPlanets(){
        planetTemplate(CGFloat(0.04*size), "mercury", nil, nil, nil, 0.6*size, 3*size)
        planetTemplate(CGFloat(0.07*size), "venus surface", nil, "venus atmosphere", nil, 0.8*size, 5*size)
        planetTemplate(CGFloat(0.15*size), "earth day", "earth specular", "earth clouds", "earth normal", 1.4*size, 8*size)
        planetTemplate(CGFloat(0.12*size), "mars", nil, nil, nil, 2*size, 13*size)
        planetTemplate(CGFloat(0.20*size), "jupiter", nil, nil, nil, 2.9*size, 15*size)
        planetTemplate(CGFloat(0.1*size), "saturn", nil, nil, nil, 3.6*size, 18*size)
        planetTemplate(CGFloat(0.07*size), "uranus", nil, nil, nil, 4.1*size, 23*size)
        planetTemplate(CGFloat(0.07*size), "neptune", nil, nil, nil, 4.5*size, 30*size)
        
        planetTemplate(CGFloat(0.35*size), "sun diffuse", nil, nil, nil, 0, 23*size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createPlanets()
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

