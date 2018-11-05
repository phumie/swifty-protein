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
    var searchArray = [String]()
    var searching = false
    
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
        } catch {
            self.showAlertController("Couldn't read the contents!")
            print("Fatal Error: Couldn't read the contents!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching) {
            return (searchArray.count)
        }
        return (array.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ligandCell")
        if (searching) {
            cell.textLabel?.text = searchArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = array[indexPath.row]
        }
        activityIndicator.stopAnimating()
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProteinViewController") as! ProteinViewController
        newViewController.passedProtein = array[indexPath.row]
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension ProteinListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray = array.filter({$0.contains(searchText)})
        searching = true
        proteinTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        proteinTable.reloadData()
    }
}
