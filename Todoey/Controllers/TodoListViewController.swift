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
    
    //After we stopped using User Defaults
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
//When we were using User Defaults
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        
        
//When we were using User Defaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }

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
        
        saveItems()

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

//Before we switched from User Defaults to NSCoder
//            //save the new itemArray to our user defaults
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")

        
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)

        //Show our alert
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Model Manipulations Methods
    
    //Created after we switched from User Defaults to NS Coder
    //Encoding
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }

        //to make the new item show up on the screen
        tableView.reloadData()

    }

    //Created after we switched from User Defaults to NS Coder
    //Decoding
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

