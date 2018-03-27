//
//  ViewController.swift
//  ToDoListSecond
//
//  Created by Hongbo Niu on 2018-03-23.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodolistViewController: SwipeTableViewController {

    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItem()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

     
       
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let items = toDoItems?[indexPath.row]{
        cell.textLabel?.text = items.title
            if let colour = UIColor(hexString:selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((toDoItems?.count)!)){
               cell.backgroundColor = colour
             cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
        
        cell.accessoryType = items.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No New Items Add"
        }
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //    MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        TODO :crud-delete data
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        if let items = toDoItems?[indexPath.row]{
            do
            {
                try realm.write {
                    items.done = !items.done
                }
           
            }catch{
                print("error updating problem")
            }
            
        }
        tableView.reloadData()
        
//         toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
       
//        saveItem()
    
      tableView.deselectRow(at: indexPath, animated: true)
    }


    //MARK: - Add New Items
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if let currentCategory = self.selectedCategory{
       do
       {
           try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
              newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
            
            }
       }catch{
        print("error saving problem \(error)")
        }
    }
            self.tableView.reloadData()
}
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new items"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //    MARK: -TableView Manipulate Methods
 

    //    TODO: retrieve data
    
    func loadItem(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

}
    //    TODO: delete data
    override func updateData(at indexPath: IndexPath) {
            
            if let item = self.toDoItems?[indexPath.row]{
                do
                {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                }catch{
                    print("problem")
                }
            }
            
        }
    

}
//MARK:- Search Bar Methods
extension TodolistViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItem(with: request,predicate: predicate)
    }
    //    TODO: go back to original list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadItem()

            DispatchQueue.main.async {

          searchBar.resignFirstResponder()

            }

        }
    }

}
