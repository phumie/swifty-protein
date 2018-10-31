//
//  ProteinViewController.swift
//  FirebaseAuth
//
//  Created by Phumudzo NEVHUTALA on 2018/10/25.
//

import UIKit
import SceneKit
import Foundation

class ProteinViewController: UIViewController {

    @IBOutlet weak var ligandLabel: UILabel!
    @IBOutlet weak var elementLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    
    var passedProtein : String = ""
    var atomData : [String]?
    var atom : Atom?
    var atoms : [Atom]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.delegate = self as? SCNSceneRendererDelegate
        
        
        if (passedProtein != ""){
            ligandLabel.text = ligandLabel.text! + " " + passedProtein
            
            let filePath = URL(string: "https://files.rcsb.org/ligands/view/" + passedProtein + "_ideal.pdb");
            URLSession.shared.dataTask(with: filePath!) { (data, response, error) in
                if error != nil {
                    print("Error loading URL.")
                    self.showAlertController("Error loading data from URL.")
                }
            }
            
            do {
                let contents = try String(contentsOf: filePath!)
                atomData = contents.components(separatedBy: "\n")
                createAtom(atomData: atomData!)
            } catch {
                self.showAlertController("Couldn't read the contents!")
                print("Fatal Error: Couldn't read the contents!")
            }
        }
    }
    
    func createAtom(atomData: [String]){
        for data in atomData {
            let temp = data.split(separator: " ")
            
            if (temp.contains("ATOM")){
                atom = Atom(_id: Int(temp[1])!, _symbol: String(temp[11]), _xPos: Double(temp[6])!, _yPos: Double(temp[7])!, _zPos: Double(temp[8])!)
            }
            else if (temp.contains("CONNECT")){
                let count = temp.count
                var index = 1
                if (Int(temp[index]) == atom?.ID){
                    index += 1
                    while (index < count){
                        atom?.setConnections(connection: Int(temp[index])!)
                        index += 1
                    }
                }
            }
            atoms?.append(atom!)
            
            //create Scene here!!!
            
            let cameraNode = SCNNode()
            let camera = SCNCamera()
            cameraNode.camera = camera
            
            self.sceneView!.scene?.rootNode.addChildNode(cameraNode)
        }
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
