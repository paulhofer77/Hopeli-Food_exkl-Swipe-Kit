//
//  UserDetailViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let realm = try! Realm()
    var userDishes: List<Dishes>?
    
    @IBOutlet weak var dishesTableView: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var selectedUser: User? {
        didSet {
            loadDishesData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userImage.image = UIImage(data: selectedUser?.userImage! as! Data)
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        if  let imageFromSelectedUser = selectedUser?.userImage {
            userImage.image = UIImage(data: imageFromSelectedUser as Data)
            userNameLabel.text = self.selectedUser?.userName
        } else {
            userImage.image = UIImage(named: "user-default-image")
            userNameLabel.text = "no User Name set"
        }
        
        
    }
            
        
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedUser?.userName
        loadDishesData()
        dishesTableView.reloadData()
        
        if selectedUser?.userName == "" {
            print("no Name")
            var userNameTextfield = UITextField()
            
            let setUserNameAlert = UIAlertController(title: "Set your Name", message: "Set your name to personalize", preferredStyle: .alert)
            
            let setUpUserNameAction = UIAlertAction(title: "Define your User Name", style: .default) { (action) in
        
                
                do {
                    try self.realm.write {
                        self.selectedUser?.userName = userNameTextfield.text!
                    }
                }catch {
                    print("Couldn´t Save Category: \(error)")
                }
                
            }
            
            setUserNameAlert.addAction(setUpUserNameAction)
            
            setUserNameAlert.addTextField { (userNameTextfield1) in
                userNameTextfield1.placeholder = "Define your User Name"
                userNameTextfield = userNameTextfield1
            }
            
            self.present(setUserNameAlert, animated: true, completion: nil)
            
        }
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        let destinationVC = segue.destination as! DefineDishesViewController
            destinationVC.selectedUser = selectedUser
        
        } else if identifier == "goToDishesDetail" {
            let destinationVC = segue.destination as! DishesDetailViewController
           
            if  let indexPath = dishesTableView.indexPathForSelectedRow {
                destinationVC.selectedDish = userDishes?[indexPath.row]
            }
        }
    }
    
    
    //    MARK: - Add Picture with ImagePicker
    @IBAction func tapGestureForImageSelection(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
//        imagePicker.cameraViewTransform = CGAffineTransform(a: 10, b: 10, c: 10, d: 10, tx: 20, ty: 20)
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                
                do {
                    try self.realm.write {
                        self.selectedUser?.userImage = NSData(data: image.jpegData(compressionQuality: 1)!)
                    }
                }catch {
                    print("Error while deleting \(error)")
                }
                self.userImage.image = image
            })
        }
        
        
    }
    
    //    MARK: - Logout Button
    
    let defaults = UserDefaults.standard
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userPasswort")
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    

}


