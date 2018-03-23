//
//  ViewController.swift
//  ToDoListSecond
//
//  Created by Hongbo Niu on 2018-03-23.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit

class TodolistViewController: UITableViewController {

    var itemArray = ["buy shoes","buy rice","buy water"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodolistArray") as?   [String]{
            itemArray = items
            
        }
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //    MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
          tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
      tableView.deselectRow(at: indexPath, animated: true)
    }


    //MARK: - Add New Items
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodolistArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new items"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

