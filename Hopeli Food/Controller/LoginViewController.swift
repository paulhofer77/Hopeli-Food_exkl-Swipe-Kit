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
    
    
    @IBOutlet weak var createUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = defaults.string(forKey: "userEmail") {
            let userPasswort = defaults.string(forKey: "userPasswort")
            loginFunction(userEmail: userEmail, userPassword: userPasswort!)

        }
    }

   
    
    func loginFunction (userEmail: String, userPassword: String) {
        
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            if error != nil {
                print("error appeared: \(error!)")
            }else {
                print("Reg successful")
                
                let userIdFromFirebase = Auth.auth().currentUser?.uid
//                hier gibt es ein Problem wenn Realm keine User hat
                self.user = self.realm.objects(User.self).filter("userId = %@", userIdFromFirebase!)
                
                self.performSegue(withIdentifier: "gotToUserFromLogin", sender: self)
            }
        }
    }
    
  
    //    MARK: - Creating a User
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
//        var textfieldUserName: UITextField = UITextField()
        var textfieldEmail: UITextField = UITextField()
        var textfieldPasswort: UITextField = UITextField()
        let alert = UIAlertController(title: "Create Your Account", message: "Set up your Account", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create User", style: .default) { (action) in
            
            Auth.auth().createUser(withEmail: textfieldEmail.text!, password: textfieldPasswort.text!) { (user, error) in
                if error != nil {
                    print("Error when signing in \(error!)")
                }else {
                    print("Registration Successful")
                    self.newUser.userId = Auth.auth().currentUser?.uid
                    self.saveData(user: self.newUser)
                    self.defaults.set(textfieldEmail.text!, forKey: "userEmail")
                    self.defaults.set(textfieldPasswort.text!, forKey: "userPasswort")
                    self.performSegue(withIdentifier: "gotToUserFromCreate", sender: self)
                    
                }
            }
    
        }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
                alert.dismiss(animated: true, completion: nil)
            }
        alert.addAction(cancelButton)
        alert.addAction(action)

        
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
        let identifier = segue.identifier
      
        if identifier == "gotToUserFromCreate" {
        destinationVC.selectedUser = newUser
        } else if identifier == "gotToUserFromLogin" {
            print("segue performing worked")
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
           
            var emailTextfieldForSingIn = UITextField()
            var passwordTextfieldForSingIn = UITextField()
            
            let alertForExistingUser = UIAlertController(title: "Login", message: "If you are already registered user your Email and Password", preferredStyle: .alert)
            
            let signInButton = UIAlertAction(title: "Sign In", style: .default) { (singIn) in
                self.loginFunction(userEmail: emailTextfieldForSingIn.text!, userPassword: passwordTextfieldForSingIn.text!)
                self.defaults.set(emailTextfieldForSingIn.text!, forKey: "userEmail")
                self.defaults.set(passwordTextfieldForSingIn.text!, forKey: "userPasswort")
                
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
                alertForExistingUser.dismiss(animated: true, completion: nil)
            }
            
            alertForExistingUser.addAction(cancelButton)
            alertForExistingUser.addAction(signInButton)
            
            alertForExistingUser.addTextField { (emailTextfield) in
                emailTextfield.placeholder = "Enter Your E-Mail Adress"
                emailTextfieldForSingIn = emailTextfield
            }
            alertForExistingUser.addTextField { (passwortTextfield) in
                passwortTextfield.placeholder = "Set your Password"
                passwordTextfieldForSingIn = passwortTextfield
            }
            
            
            self.present(alertForExistingUser, animated: true, completion: nil)
            
//        loginButton.isHidden = false
//        loginPasswortTextfield.isHidden = false
//        loginEmailTextfield.isHidden = false
           
       
        }
    }
    

}








