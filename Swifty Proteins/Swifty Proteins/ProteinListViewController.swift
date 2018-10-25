//
//  ProteinListViewController.swift
//  Swifty Proteins
//
//  Created by Phumudzo NEVHUTALA on 2018/10/25.
//  Copyright © 2018 Phumudzo NEVHUTALA. All rights reserved.
//

import UIKit

class ProteinListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var proteinTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var array: [String] = []
    var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableview
        proteinTable.dataSource = self
        proteinTable.delegate = self
        
        
        //setup activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        //load data from the URL into the array
        activityIndicator.startAnimating()
        let filePath = URL(string: "https://projects.intra.42.fr/uploads/document/document/312/ligands.txt");        URLSession.shared.dataTask(with: filePath!) { (data, response, error) in
            if error != nil {
                print("Error loading URL.")
                self.showAlertController("Error loading data from URL.")
            }
        }
        
        do {
            let contents = try String(contentsOf: filePath!)
            array = contents.components(separatedBy: "\n")
            print(array)
        } catch {
            self.showAlertController("Couldn't read the contents!")
            print("Fatal Error: Couldn't read the contents!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (array.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(array.count)
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ligandCell")
        cell.textLabel?.text = array[indexPath.row]
        activityIndicator.stopAnimating()
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProteinView")
        self.present(newViewController, animated: true, completion: nil)
        
        print("Cell cliked value is: " + array[indexPath.row])
    }
    
    @IBAction func closeBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
