//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Brandi D Gremillion on 6/25/18.
//  Copyright © 2018 Gremillion Consulting. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    //To get access to our AppDelegate as an object to be able to use it's properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //To see where our Core Data SQLite database is being stored
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        //Another way to update data is this
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        saveItems()

        //So the row will flash gray and then go back to white when the user clicks it
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //Have to remove this item from context before removing it from itemArray
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            saveItems()

        }
    }
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            

            //newItem is essentially a row (NSManagedObject) in the table Item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
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
    
    func saveItems() {

        do {
            try context.save()
        } catch {
            print("Error saving item \(error)")
        }
        
        //to make the new item show up on the screen
        tableView.reloadData()

    }

    //Takes in a parameter (with is the external parameter, request is the internal
    //parameter), but if one isn't passed, uses the default Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching item data from context \(error)")
        }
    
        tableView.reloadData()
        
    }
    
}


//MARK: Search Bar Methods

//This is an extension of our TodoListViewController class
//Allows us to separate our code by functionality
extension TodoListViewController : UISearchBarDelegate {
    
    //Search Bar delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: predicate)
        
    }

    //Triggered each time a character is entered or deleted in the search bar or if the x
    //button is clicked
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            //Manages the execution of work items, background vs instant tasks running in the app as threads
            //Asking the DispatchQueue to get the main queue (thread)
            DispatchQueue.main.async {
                //Telling the search bar to stop being the first responder so that the cursor
                //will not be flashing in the search bar and the keyboard will disappear
                //So it will no longer be the selected item
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}

