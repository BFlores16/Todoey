//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Brando Flores on 12/6/20.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var toDoItems : Results<Item>?
    var selectedCategory : Category? {
        // Anything between will happen as soon as selectedCategory gets set
        // with a value
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Used for NSUserDefault persistent storage
    let defaults = UserDefaults.standard
    
    // Creating a new user data location instead of NSUserDefault
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change back button to white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    /*
        Return the number of items in the table view.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    /*
        Provide the cells for the table view. Displayed as a row.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            // Ternary operator ==>
            // value = condition ? valueIfTrue : ValueIfFalse
            // Set the cell accessory depending on whether the cell is in
            // done or not done condition
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
    
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    /*
        Actions performed when row is selected
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    /*
                        Conditional checkmark when user selects a cell
                        Changes the bool condition from false to true or true to false
                     */
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // Unhighlight row after it is selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Local variable used to refer to alert text field in any scope
        var textField = UITextField()
        
        // Create the alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // Create a cancel button for the alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            // Possible to do this but unecessary because the style handles it
            //self.dismiss(animated: true, completion: nil)
        }
        
        // Create an add button for the alert
        let addAction = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving item, \(error)")
                }
            }
                
            tableView.reloadData()
        }
        
        /*
            Remember, that in this closure, actions do not happen until after the text field is added to the alert, which does not happen until the "action" completion block completes.
            Be mindful of asynchrounous calls
         */
        alert.addTextField { (alertTextField) in
            // This is a local variable, we need to assign it to another variable to be able to access outside this scope
            alertTextField.placeholder = "Create New Item."
            textField = alertTextField
            
            // Remember that this line will print empty because the addTextField closure completes before the "action" closure
            print("First: \(textField.text ?? "")")
        }
        
        // Order of adding will determine order in alert.
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    
    
    //MARK: - Model Manipulation Methods
    /*
        Get data from Core Data and reload the table view
     */
    // Function input allows a default value of Item.fetchRequest()
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - SearchBar delegate functions
extension TodoListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
        
            DispatchQueue.main.async {
                // Dismiss keyboard and close active search bar
                searchBar.resignFirstResponder()
            }
        }
    }
}
