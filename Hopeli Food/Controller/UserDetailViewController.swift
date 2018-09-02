//
//  UserDetailViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let realm = try! Realm()
    var userDishes: List<Dishes>?
    
    @IBOutlet weak var dishesTableView: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var selectedUser: User? {
        didSet {
            loadDishesData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.image = UIImage(data: selectedUser?.userImage! as! Data)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedUser?.userName
        loadDishesData()
        dishesTableView.reloadData()
    }
    
   

    //MARK: - Data Mathods
    func loadDishesData () {
        userDishes = selectedUser?.dishes
      
    }
    
    func updateModel(at indexPath: IndexPath) {
    
        if let dishDelete = self.userDishes?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(dishDelete)
                }
            }catch {
                print("Error while deleting \(error)")
            }
        }
    }
    
    
    //MARK: - Table View View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDishes?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dishesTableView.dequeueReusableCell(withIdentifier: "dishesCell", for: indexPath)
        
        if let dish = userDishes?[indexPath.row] {
            cell.textLabel?.text = dish.dishName
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            updateModel(at: indexPath)
            loadDishesData()
            dishesTableView.reloadData()
        }
        
    }
    
    //    MARK: - going to Detail Dishes Overview
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDishesDetail", sender: self)
        
        dishesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //    MARK: - Add a new Dish
    @IBAction func addDishButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToDishes", sender: self)
        
    }
    
    //    MARK: - Prepare for Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == "goToDishes" {
        let destinationVC = segue.destination as! DishesTableViewController
            destinationVC.selectedUser = selectedUser
        
        } else if identifier == "goToDishesDetail" {
            let destinationVC = segue.destination as! DishesDetailViewController
           
            if  let indexPath = dishesTableView.indexPathForSelectedRow {
                destinationVC.selectedDish = userDishes?[indexPath.row]
            }
        }
    }
    

}


