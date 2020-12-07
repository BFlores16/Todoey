//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Brando Flores on 12/6/20.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // Used for NSUserDefault persistent storage
    let defaults = UserDefaults.standard
    
    // Creating a new user data location instead of NSUserDefault
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

        // Load the data from NSUserDefault
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    // MARK: - Table view data source

    /*
        Return the number of sections in the table view. Return 1 or comment out function for no sections.
     */
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/

    /*
        Return the number of items in the table view.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    /*
        Provide the cells for the table view. Displayed as a row.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : ValueIfFalse
        // Set the cell accessory depending on whether the cell is in
        // done or not done condition
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    /*
        Actions performed when row is selected
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
            Conditional checkmark when user selects a cell
            Changes the bool condition from false to true or true to false
         */
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // Unhighlight row after it is selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
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
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Action once user clicks "Add Item"
            
            // This gets triggered after alert.addTextField closure
            print("Second: \(textField.text ?? "")")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
        
            
            self.saveItems()
        }
        
        /*
            Remember, that in this closure, actions do not happen until after the text field is added to the alert, which does not happen until the "action" completion block completes.
            Be mindful of asynchrounous calls
         */
        alert.addTextField { (alertTextField) in
            // This is a local variable, we need to assign it to another variable to be able to access outside this scope
            alertTextField.placeholder = "Create new item."
            textField = alertTextField
            
            // Remember that this line will print empty because the addTextField closure completes before the "action" closure
            print("First: \(textField.text ?? "")")
        }
        
        // Order of adding will determine order in alert.
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manipulation Methods
    /*
        Use NSCoder to encode item array data into plist file to retrieve from later
     */
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    /*
        Use NSCoder to decode data from plist file and update to item array
     */
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
            print("Error decoding item array, \(error)")
            }
        }
    }
    
}
