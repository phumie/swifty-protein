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
    var atoms : [Atom] = []

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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(elementTapped(tap:)))
        self.sceneView.addGestureRecognizer(tap)
    }
    
    func createAtom(atomData: [String]){
        for data in atomData {
            let temp = data.split(separator: " ")
            
            if (temp.contains("ATOM")){
                atom = Atom(_id: Int(temp[1])!, _symbol: String(temp[11]), _xPos: Double(temp[6])!, _yPos: Double(temp[7])!, _zPos: Double(temp[8])!)
                atoms.append(atom!)
            }
            else if (temp.contains("CONECT")){
                let count = temp.count
                var index = 1
                
                for a in atoms {
                    if (Int(temp[index]) == a.ID){
                        index += 1
                        while (index < count){
                            a.setConnections(connection: Int(temp[index])!)
                            index += 1
                        }
                    }
                    index = 1
                }
            }
        }
        
        
        self.sceneView.scene = AtomsView(ligands: atoms)

        let cameraNode = SCNNode()
        let camera = SCNCamera()

        cameraNode.camera = camera
        self.sceneView!.scene?.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3Make(0, 0, 50)

        self.sceneView.backgroundColor = UIColor.white
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = true
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func elementTapped(tap : UITapGestureRecognizer){
        if tap.state == .ended {
            let location: CGPoint = tap.location(in: self.sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                if tappedNode?.name != "" &&  tappedNode?.name != nil {
                    elementLabel.text = "Element Clicked: " + (tappedNode?.name!)!
                }
            }
            else{
                elementLabel.text = "Element Clicked: "
            }
        }
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let image = self.sceneView.snapshot()
        let activityVC = UIActivityViewController(activityItems: [(image)], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}
