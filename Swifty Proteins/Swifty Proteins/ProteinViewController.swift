//
//  ProteinViewController.swift
//  FirebaseAuth
//
//  Created by Phumudzo NEVHUTALA on 2018/10/25.
//

import UIKit

class ProteinViewController: UIViewController {

    @IBOutlet weak var ligandLabel: UILabel!
    @IBOutlet weak var elementLabel: UILabel!
    
    var passedProtein : String = ""
    var atomData : [String]?
    var atom : Atom?
    var atoms : [Atom]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            } catch {
                self.showAlertController("Couldn't read the contents!")
                print("Fatal Error: Couldn't read the contents!")
            }
        }
    }
    
    func createAtom(atomData: [String]){
        for data in atomData {
            let temp = data.components(separatedBy: " ")
            
            if (temp[0] == "ATOM"){
                atom = Atom(_id: Int(temp[1])!, _symbol: temp[10], _xPos: Double(temp[6])!, _yPos: Double(temp[7])!, _zPos: Double(temp[8])!)
            }
            else if (temp[0] == "CONNECT"){
                //add connections to the atom
                if (Int(temp[1]) == atom?.ID){
                    
                }
            }
            
            atoms?.append(atom!)
        }
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
