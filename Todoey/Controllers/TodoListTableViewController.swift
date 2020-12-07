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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "Save the world"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem3)

        // Load the data from NSUserData
        //if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
        //    itemArray = items
        //}
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    /*
        Return the number of sections in the table view. Return 1 or comment out function for no sections.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
        Return the number of items in the table view.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    /*
        Provide the cells for the table view. Displayed as a row.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if ( itemArray[indexPath.row].done ) {
            // Add checkmark accessory
            cell.accessoryType = .checkmark
        }
        else {
            // Remove checkmark accessory
            cell.accessoryType = .none
        }
        
        // Reload the table view to call its data source methods so that it will update to user
        tableView.reloadData()
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK - TableView Delegate Methods
    
    /*
        Actions performed when row is selected
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
            Conditional checkmark when user selects a cell
         */
        if itemArray[indexPath.row].done {
            itemArray[indexPath.row].done = false
        }
        else {
            itemArray[indexPath.row].done = true
        }
        
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
            
            // Store the data in NSUserData
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Table view will not update without this
            self.tableView.reloadData()
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
    
}
