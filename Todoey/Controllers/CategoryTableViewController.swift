//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Brando Flores on 12/7/20.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Functions
    
    /*
        Actions performed when row is selected
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Highlight and deselect
        // Keep in mind that deselcting will unwrap nil later if you attempt
        // to get indexPath
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            let vc = segue.destination as! TodoListTableViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                vc.selectedCategory = categoryArray?[indexPath.row]
            }
            
        }
    }
    
    //MARK: - Data Manipulation Functions
    
    /*
        Write data to Realm
     */
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
    }
    
    /*
        Get data from Realm
     */
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Add Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Local variable used to refer to alert text field in any scope
        var textField = UITextField()
        
        // Create alert
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        // Create a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Create add action
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            // Save category to Realm
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category."
            textField = alertTextField
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    
}

//MARK: - Swipe Table View Delegate
extension CategoryTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (SwipeAction, indexPath) in
            // handle action by updating model with deletion
            
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                }
                catch {
                    print("Error deleting category, \(error)")
                }
            }
        
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    
}
