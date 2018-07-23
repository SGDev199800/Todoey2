//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Saurav Gupta on 08/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        loadCategories()
    }

    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //this will happen once user press ADD ITEM button
            
            let newCategory = Category()
            newCategory.name = textField.text!
       
            self.save(category: newCategory)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
          
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
            alert.addAction(action)
            alert.addAction(cancelAction)
        
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "create new category"
                textField = alertTextField
            }
            
            present(alert, animated: true, completion: nil)
    }
    
    //MARK: - table view datasoursce methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // new type of code - nil coalasing operator
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category"
        
        return cell
    }
    
    //MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - data manupilation methods
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }

    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)

       tableView.reloadData()
    }
    
}
