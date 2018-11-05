//
//  AtomsView.swift
//  Swifty Proteins
//
//  Created by Phumudzo NEVHUTALA on 2018/10/31.
//  Copyright © 2018 Phumudzo NEVHUTALA. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class AtomsView : SCNScene {
    var atoms : [SCNNode] = []
    
    init(ligands : [Atom]){
        super.init()
        
        let sphere = SCNSphere(radius: 2)
        let sphereNode = SCNNode(geometry: sphere)
        self.atoms.append(sphereNode)
        
        for ligand in ligands {
            //CREATE ATOM SPHERE
            let sphere = SCNSphere(radius: 0.5)
            let sphereNode = SCNNode(geometry: sphere)
            
            sphereNode.position = SCNVector3Make(Float(ligand.xPos), Float(ligand.yPos), Float(ligand.zPos))
            sphereNode.name = ligand.symbol
            pickColour(symbol: ligand.symbol, sphere: sphere)
            self.rootNode.addChildNode(sphereNode)
            self.atoms.append(sphereNode)
        }
        
        for ligand in ligands {
            //ADD CONNECTIONS TO SPHERE
            let connections : [Int] = ligand.getConnections()
            
            let from = ligand.ID
            for to in connections {
                let connection = drawConnections(vector: atoms[from].position, vector2: atoms[to].position)
                self.rootNode.addChildNode(connection)
            }
        }
    }
    
    func pickColour(symbol: String, sphere: SCNSphere){
        switch symbol {
        case "H":
            sphere.firstMaterial?.diffuse.contents = UIColor.white
        case "C":
            sphere.firstMaterial?.diffuse.contents = UIColor.black
        case "N":
            sphere.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0.0039, blue: 0.4078, alpha: 1.0) //darkblue
        case "O":
            sphere.firstMaterial?.diffuse.contents = UIColor.red
        case "F", "Cl":
            sphere.firstMaterial?.diffuse.contents = UIColor.green
        case "Br":
            sphere.firstMaterial?.diffuse.contents = UIColor(red: 0.6667, green: 0, blue: 0.0078, alpha: 1.0) //dark red
        case "He", "Ne", "Ar", "Xe", "Kr":
            sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        case "P":
            sphere.firstMaterial?.diffuse.contents = UIColor.orange
        case "S":
            sphere.firstMaterial?.diffuse.contents = UIColor.yellow
        case "B":
            sphere.firstMaterial?.diffuse.contents = UIColor(red: 0.9765, green: 0.5098, blue: 0.2902, alpha: 1.0) //peach
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            sphere.firstMaterial?.diffuse.contents = UIColor.purple
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            sphere.firstMaterial?.diffuse.contents = UIColor(red: 0.0667, green: 0.5176, blue: 0, alpha: 1.0)//dark green
        case "Ti":
            sphere.firstMaterial?.diffuse.contents = UIColor.gray
        case "Fe":
            sphere.firstMaterial?.diffuse.contents = UIColor(red: 0.8392, green: 0.4471, blue: 0, alpha: 1.0) //dark orange
        default:
            sphere.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 0.2392, blue: 0.5804, alpha: 1.0) //pink
        }
    }
    
    func drawConnections(vector vector1: SCNVector3, vector2: SCNVector3) -> SCNNode {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: SCNGeometryPrimitiveType.line)
    
        let line = SCNGeometry(sources: [source], elements: [element])
        line.firstMaterial?.diffuse.contents = UIColor.black

        return SCNNode(geometry: line)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
