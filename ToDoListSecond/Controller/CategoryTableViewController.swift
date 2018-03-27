//
//  CategoryTableViewController.swift
//  ToDoListSecond
//
//  Created by Hongbo Niu on 2018-03-23.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categoryArray : Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategory()
       

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No New Category Add"
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].colour ?? "739DF6")
        
        return cell
    }
    
    //    MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolistViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
 
    //MARK: - Add New Category
    @IBAction func addNewCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
//            what will happen after the user click the button

            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category:newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Manipulate Methods
    //    TODO: Save data
    func save(category:Category){
        do
        {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("saving problem \(error)")
        }
        tableView.reloadData()
    }
    
    //    TODO: Load data
    func loadCategory(){

        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateData(at indexPath : IndexPath){
        
      if let category = self.categoryArray?[indexPath.row]{
                                    do
                                    {
                                        try self.realm.write {
                                            self.realm.delete(category)
                                        }
                                    }catch{
                                        print("problem")
                                    }
                                }

    }
    
}


