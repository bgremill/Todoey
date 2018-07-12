//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Brandi D Gremillion on 6/25/18.
//  Copyright © 2018 Gremillion Consulting. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Using the new class
        let newItem = Item()
        newItem.title = "Walmart"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "CVS"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Kohl's"
        itemArray.append(newItem3)

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }

    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType = item.done == true ? .checkmark : .none
        cell.accessoryType = item.done ? .checkmark : .none
        
//The ternary operator replaces these lines in the one line above
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    //This method gets called when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Sets the done property on the current item to the opposite of what it is right now
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()

//Code before we added the Item Data Model
//        //Add or remove a checkmark when selected
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //So the row will flash gray and then go back to white when the user clicks it
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Inside addButtonPressed")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the add item button on our UIAlert
            
            //add our new item to our array
            //Used before we created the Item Data Model
            //self.itemArray.append(textField.text!)
            
            //Using the new Item Data Model
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
        
            print("Inside addButtonPressed after append")
            
            //save the new itemArray to our user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            print("Inside addButtonPressed after save")
            
            //to make the new item show up on the screen
            self.tableView.reloadData()
            
            print("Inside addButtonPressed after reload")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Inside alert.addTextField")
        }
        
        alert.addAction(action)
        
        print("Inside addButtonPressed after alert.addAction")
        
        //Show our alert
        present(alert, animated: true, completion: nil)
        
        print("Inside addButtonPressed after present")
        
        
    }
    
}

