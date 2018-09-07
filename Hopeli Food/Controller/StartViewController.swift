//
//  ViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var userTableView: UITableView!
    
    let realm = try! Realm()
    var user: Results<User>?

    @IBOutlet weak var userTextlabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
        userTableView.rowHeight = 80
    }

    //    MARK: - Data Model Manipulation
    func saveData(user: User) {
        do {
            try realm.write {
                realm.add(user)
            }
        }catch {
            print("Couldn´t Save Category: \(error)")
        }
        userTableView.reloadData()
    }
    
    func loadData () {
        
        user = realm.objects(User.self)
        userTableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        
        if let userDelete = self.user?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(userDelete)
                }
            }catch {
                print("Error while deleting \(error)")
            }
        }
    }

   //    MARK: - Add User
    
    @IBAction func addUserButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield: UITextField = UITextField()
        let alert = UIAlertController(title: "New User", message: "Add your Account", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add User", style: .default) { (action) in
            let newUser = User()
            newUser.userName = textfield.text!
//            newUser.userId = self.user?.count ?? 0 + 1
        
            let image = UIImage(named: "user-default-image")
            newUser.userImage = NSData(data: UIImagePNGRepresentation(image!)!)

            self.saveData(user: newUser)
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create your Account"
            textfield = alertTextfield
        }
        
        present(alert, animated: true, completion: nil)
        
    }
        
//    MARK: - Tabel View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        cell.cellLabel.text = user?[indexPath.row].userName ?? "add a User"
        cell.cellImage.image = UIImage(data: user?[indexPath.row].userImage as! Data)
    
        return cell
    }
    
// MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToUser", sender: self)
        userTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UserDetailViewController
        
        if let indexPath = userTableView.indexPathForSelectedRow {
            destinationVC.selectedUser = user?[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            updateModel(at: indexPath)
            loadData()
            }
            
        }
    
    
    //MARK: Image Picker Methoads
//
//    let imagePicker = UIImagePickerController()
//    imagePicker.sourceType = .photoLibrary
//    imagePicker.delegate = self
//    self.present(imagePicker, animated: true, completion: nil)
//
//func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    picker.dismiss(animated: true, completion: nil)
//}
//
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//        picker.dismiss(animated: true, completion: {
////            self.createItem(with: image)
//        })
//    }
//
//
//}
    
    
    
    
}






