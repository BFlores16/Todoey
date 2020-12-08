//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Brando Flores on 12/7/20.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Data Manipulation Functions
    
    //MARK: - TableView Datasource Functions

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    //MARK: - TableView Delegate Functions

    
}
