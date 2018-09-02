//
//  DishesTableViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class DishesTableViewController: UITableViewController {

    let realm = try! Realm()
    var dishes: Results<Dishes>?
    
    var selectedUser: User? {
        didSet {
            loadDishes()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dishes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dishesCell", for: indexPath)
        cell.textLabel?.text = dishes?[indexPath.row].dishName ?? "Add your First Dish"
        
        return cell
    }
    
    //    Mark: - Tabele Delegate Methods
    
    
    

    
    //    Mark: - Data Model Manipulation
    
    func loadDishes() {
        dishes = selectedUser?.dishes.sorted(byKeyPath: "dishTimestamp", ascending: true)
        tableView.reloadData()
    }
    
    
    //    MARK: - Add new Dish
   
    @IBAction func addDishButton(_ sender: UIButton) {
        
        var textField: UITextField = UITextField()
        let alert = UIAlertController(title: "New Dish", message: "Add a new Dish", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Dish", style: .default) { (action) in
            
            if let currentUser = self.selectedUser {
                do {
                    try self.realm.write {
                        let newDish = Dishes()
                        newDish.dishName = textField.text!
                        newDish.dishTimestamp = Date()
                        newDish.users.append(currentUser)
                        currentUser.dishes.append(newDish)
                    }
                }catch {
                    print("Couldn´t Save Category: \(error)")
                }
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create your Account"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
}
