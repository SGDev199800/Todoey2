//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Saurav Gupta on 08/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import UIKit
import CoreData

var categoryArray = [Category]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class CategoryViewController: UITableViewController {

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
            
            let newCategory = Category(context: context)
            newCategory.name = textField.text!
            
            categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
            alert.addAction(action)
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "create new category"
                textField = alertTextField
            }
            
            present(alert, animated: true, completion: nil)
    }
    
    //MARK: - table view datasoursce methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - data manupilation methods
    func saveCategories(){
        
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    //             If request not provided                default value
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
}
