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
        
        let sphere = SCNSphere(radius: 0.3)
        let sphereNode = SCNNode(geometry: sphere)
        self.atoms.append(sphereNode)
        
        for ligand in ligands {
            //CREATE ATOM SPHERE
            let sphere = SCNSphere(radius: 0.3)
            let sphereNode = SCNNode(geometry: sphere)
            
            sphereNode.position = SCNVector3Make(Float(ligand.xPos), Float(ligand.yPos), Float(ligand.yPos))
            sphereNode.name = ligand.symbol
            pickColour(symbol: ligand.symbol, sphere: sphere)
            self.rootNode.addChildNode(sphereNode)
            self.atoms.append(sphereNode)
            
            //ADD CONNECTIONS TO SPHERE
        }
    }
    
    func pickColour(symbol: String, sphere: SCNSphere){
        switch symbol {
        case "H":
            sphere.firstMaterial?.diffuse.contents = UIColor.white
        case "C":
            sphere.firstMaterial?.diffuse.contents = UIColor.black
        case "N":
            sphere.firstMaterial?.diffuse.contents = UIColor.blue //darkblue
        case "O":
            sphere.firstMaterial?.diffuse.contents = UIColor.red
        case "F", "Cl":
            sphere.firstMaterial?.diffuse.contents = UIColor.green
        case "Br":
            sphere.firstMaterial?.diffuse.contents = UIColor.red //dark red
        case "He", "Ne", "Ar", "Xe", "Kr":
            sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        case "P":
            sphere.firstMaterial?.diffuse.contents = UIColor.orange
        case "S":
            sphere.firstMaterial?.diffuse.contents = UIColor.yellow
        case "B":
            sphere.firstMaterial?.diffuse.contents = UIColor.orange //peach
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            sphere.firstMaterial?.diffuse.contents = UIColor.purple
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            sphere.firstMaterial?.diffuse.contents = UIColor.green //dark green
        case "Ti":
            sphere.firstMaterial?.diffuse.contents = UIColor.gray
        case "Fe":
            sphere.firstMaterial?.diffuse.contents = UIColor.orange //dark orange
        default:
            sphere.firstMaterial?.diffuse.contents = UIColor.purple //pink
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
