//
//  LoginViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 02.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class LoginViewController: UIViewController {

    let realm = try! Realm()
    var user: Results<User>?
    let newUser = User()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isHidden = true
        loginPasswortTextfield.isHidden = true
        loginEmailTextfield.isHidden = true
        if let userEmail = defaults.string(forKey: "userEmail") {
            let userPasswort = defaults.string(forKey: "userPasswort")
            loginEmailTextfield.text = userEmail
            loginPasswortTextfield.text = userPasswort
            loginFunction()
            
//            createUserButton.isHidden = true
            
        }
        // Do any additional setup after loading the view.
    }

   
    @IBOutlet weak var loginEmailTextfield: UITextField!
    @IBOutlet weak var loginPasswortTextfield: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        loginFunction()
        
    }
    
    func loginFunction () {
        
        
        
        Auth.auth().signIn(withEmail: loginEmailTextfield.text!, password: loginPasswortTextfield.text!) { (user, error) in
            if error != nil {
                print("error appeared: \(error!)")
            }else {
                print("Reg successful")
                
                let userIdFromFirebase = Auth.auth().currentUser?.uid
                self.user = self.realm.objects(User.self).filter("userId = %@", userIdFromFirebase)
                
                self.performSegue(withIdentifier: "gotToUserFromLogin", sender: self.loginButton)
            }
        }
    }
    
  
    //    MARK: - Creating a User
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
        var textfieldUserName: UITextField = UITextField()
        var textfieldEmail: UITextField = UITextField()
        var textfieldPasswort: UITextField = UITextField()
        let alert = UIAlertController(title: "Create Your Account", message: "Set up your Account", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create User", style: .default) { (action) in
            
            self.newUser.userName = textfieldUserName.text!
//            self.newUser.userEmail = textfieldEmail.text!
//            self.newUser.userPasswort = textfieldPasswort.text!
//            self.newUser.userId = self.user?.count ?? 0 + 1
            self.defaults.set(textfieldEmail.text!, forKey: "userEmail")
            self.defaults.set(textfieldPasswort.text!, forKey: "userPasswort")
            
            Auth.auth().createUser(withEmail: textfieldEmail.text!, password: textfieldPasswort.text!) { (user, error) in
                if error != nil {
                    print(error!)
                }else {
                    print("Registration Successful")
                    self.newUser.userId = Auth.auth().currentUser?.uid
                    self.saveData(user: self.newUser)
                    self.performSegue(withIdentifier: "gotToUserFromCreate", sender: self)
                    
                }
            }
    
        }
        
        alert.addAction(action)
        alert.addTextField { (userNameTextfield) in
            userNameTextfield.placeholder = "Set your User Name"
            textfieldUserName = userNameTextfield
        }
        
        alert.addTextField { (emailTextfield) in
            emailTextfield.placeholder = "EnterYour E-Mail Adress"
            textfieldEmail = emailTextfield
        }
        alert.addTextField { (passwortTextfield) in
            passwortTextfield.placeholder = "Set your Passwort"
            textfieldPasswort = passwortTextfield
        }
        
        
        present(alert, animated: true, completion: nil)
        
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UserDetailViewController
        var identifier = segue.identifier
      
        if identifier == "gotToUserFromCreate" {
        destinationVC.selectedUser = newUser
        } else if identifier == "gotToUserFromLogin" {
            destinationVC.selectedUser = user?[0]
        }
    }
    
    //    MARK: - Data Manipulation
    func loadData () {
        user = realm.objects(User.self)
    }
    
        func saveData(user: User) {
            do {
                try realm.write {
                    realm.add(user)
                }
            }catch {
                print("Couldn´t Save Category: \(error)")
            }
        }
    
    
    @IBAction func useExistingUserButtonPressed(_ sender: UIButton) {
        if sender.tag == 2 {
        loginButton.isHidden = false
        loginPasswortTextfield.isHidden = false
        loginEmailTextfield.isHidden = false
        }
    }
    

}
