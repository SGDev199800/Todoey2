//
//  ViewController.swift
//  Todoey2
//
//  Created by Saurav Gupta on 04/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
    
        didSet{
            loadItems()
        }
        
    }
    
//    The below line is used for NSencoder method
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//MARK: - tableView Datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//  ternary operator
//  value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//   this line will replace the DONE property of the element of itemArray to opposite to current state
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItem()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Alert functionality
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this will happen once user press ADD ITEM button
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
        
            self.itemArray.append(newItem)
            
            self.saveItem()
        }
        
        alert.addAction(action)
       
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data manupilation methods
    
    func saveItem(){
        
        do{
            try context.save()
        }
        catch{
           print(error)
        }
        
        tableView.reloadData()
        
    }
    
    //             If request not provided                default value
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = compoundPredicate
        
        
        do{
             itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()

    }
    
}

//MARK: - SearchBar functionality

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.7, animations: {searchBar.resignFirstResponder()})
            }
           
        }
    }
    
}
    



