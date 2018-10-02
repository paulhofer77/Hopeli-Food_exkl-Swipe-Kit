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
    
    
//    MARK: - Outlets for PopUpView
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpInfoLabel: UILabel!
    @IBOutlet weak var popUpExistingUserLabal: UILabel!
    @IBOutlet weak var popUpUserNameTextfield: UITextField!
    @IBOutlet weak var popUpEmailTextfield: UITextField!
    @IBOutlet weak var popUpPasswordTextfield: UITextField!
    @IBOutlet weak var popUpStatusLabel: UILabel!
    @IBOutlet weak var popUpCreateButton: UIButton!
    @IBOutlet weak var popUpCancelButton: UIButton!
    
    
    var popUpIdentifier: Int?
    
 //    MARK: - Outlets User Button
    
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var useExistingUeerButton: UIButton!
    
 //    MARK: - ViewDid Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.isHidden = true
        
        if let userEmail = defaults.string(forKey: "userEmail") {
            let userPasswort = defaults.string(forKey: "userPasswort")
            loginFunction(userEmail: userEmail, userPassword: userPasswort!)

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
    
    func loginFunction (userEmail: String, userPassword: String) {
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            if error != nil {
                print("error appeared: \(error!)")
                self.popUpStatusLabel.text = error?.localizedDescription
            }else {
                print("Reg successful")
                
                let userIdFromFirebase = Auth.auth().currentUser?.uid
                self.user = self.realm.objects(User.self).filter("userId = %@", userIdFromFirebase!)
                
                if self.user?.count == 0 {
                    self.popUpStatusLabel.text = "User is not available, please get in touch with us"
                }else {
                    self.performSegue(withIdentifier: "gotToUserFromLogin", sender: self)
                }
            }
        }
    }
    
    //    MARK: - Prepare for Segue
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
    
  
    //    MARK: - Creating a User
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            
            popUpView.isHidden = false
            popUpInfoLabel.text = "Create your Account"
            popUpStatusLabel.text = "Enter your email Adress and your Password"
            popUpIdentifier = 1
            popUpPasswordTextfield.placeholder = "password (use at least 6 characters)"
            popUpCreateButton.titleLabel?.text = "Create"
            popUpExistingUserLabal.isHidden = true
            popUpUserNameTextfield.isHidden = false
            createUserButton.isHidden = true
            useExistingUeerButton.isHidden = true
       
        }
    }

    //    MARK: - Login with Existing User
    @IBAction func useExistingUserButtonPressed(_ sender: UIButton) {
        if sender.tag == 2 {
           
            popUpView.isHidden = false
            popUpInfoLabel.text = "Sign in with your credentials"
            popUpIdentifier = 2
            popUpStatusLabel.text = "Enter your email Adress and your Password"
            popUpPasswordTextfield.placeholder = "your Hopeli Food password"
            popUpCreateButton.titleLabel?.text = "Sign In"
            popUpExistingUserLabal.isHidden = false
            popUpExistingUserLabal.text = "Welcome Back to Hopeli Food"
            popUpUserNameTextfield.isHidden = true
            createUserButton.isHidden = true
            useExistingUeerButton.isHidden = true
       
        }
    }
    
    
    //    MARK: - PopUpCancel Button Pressed
    
    @IBAction func popUpCancelButtonPRessed(_ sender: UIButton) {
        popUpView.isHidden = true
        
        popUpEmailTextfield.text = ""
        popUpPasswordTextfield.text = ""
        popUpCreateButton.titleLabel?.text = ""
        
        createUserButton.isHidden = false
        useExistingUeerButton.isHidden = false
        
    }
    
    //    MARK: - EMail Verification
    
//    var actionCodeSettings = ActionCodeSettings.init()
//        actionCodeSettings.canHandleInApp = true
//    let user = Auth.auth().currentUser()
//    actionCodeSettings.URL = String(format: "https://www.example.com/?email=%@", user.email)
//    actionCodeSettings.iOSbundleID = Bundle.main.bundleIdentifier!
//    actionCodeSettings.setAndroidPakageName("com.example.android",
//    installIfNotAvailable:true,
//    minumumVersion:"12")
//    user.sendEmailVerification(withActionCodeSettings:actionCodeSettings { error in
//    if error {
//    // Error occurred. Inspect error.code and handle error.
//    return
//    }
//    // Email verification sent.
//    })
    
    
    //    MARK: - PopUpCreate Button Pressed
    
    @IBAction func popUpCreateButtonPressed(_ sender: UIButton) {
        
        if popUpIdentifier == 1 {
            
            if popUpEmailTextfield.text?.count != 0 && popUpPasswordTextfield.text?.count ?? 0 != 0 && popUpUserNameTextfield.text?.count != 0 {
                print("Everythings fine")
                
                Auth.auth().createUser(withEmail: popUpEmailTextfield.text!, password: popUpPasswordTextfield.text!) { (user, error) in
                    if error != nil {
                        print("Error when signing in \(error!)")
                        self.popUpStatusLabel.text = error?.localizedDescription

                    }else {
                        print("Registration Successful")
                        self.newUser.userId = Auth.auth().currentUser?.uid
                        self.newUser.userName = self.popUpUserNameTextfield.text!
                        self.saveData(user: self.newUser)
                        self.defaults.set(self.popUpEmailTextfield.text!, forKey: "userEmail")
                        self.defaults.set(self.popUpPasswordTextfield.text!, forKey: "userPasswort")
                        self.performSegue(withIdentifier: "gotToUserFromCreate", sender: self)
                        
                    }
                }
                
                
//            }else if popUpEmailTextfield.text?.count != 0 && popUpPasswordTextfield.text?.count == 0{
//                popUpStatusLabel.text = "Please enter a password with at least 6 characters"
//                
//            }else if popUpEmailTextfield.text?.count == 0 && popUpPasswordTextfield.text?.count != 0{
//                popUpStatusLabel.text = "Please enter your email"
            }else if popUpEmailTextfield.text?.count == 0 || popUpPasswordTextfield.text?.count == 0 || popUpUserNameTextfield.text?.count == 0{
                popUpStatusLabel.text = "One of the 3 required Fields is empty"
            }
                
            
            
        }else if popUpIdentifier == 2 {
            
            self.loginFunction(userEmail: popUpEmailTextfield.text!, userPassword: popUpPasswordTextfield.text!)
            self.defaults.set(popUpEmailTextfield.text!, forKey: "userEmail")
            self.defaults.set(popUpPasswordTextfield.text!, forKey: "userPasswort")
            
            
            
        }
        
        
    }
    
}

//  MARK: - How I did it with an Alert
//var emailTextfieldForSingIn = UITextField()
//            var passwordTextfieldForSingIn = UITextField()
//
//            let alertForExistingUser = UIAlertController(title: "Login", message: "If you are already registered user your Email and Password", preferredStyle: .alert)
//
//            let signInButton = UIAlertAction(title: "Sign In", style: .default) { (singIn) in
//                self.loginFunction(userEmail: emailTextfieldForSingIn.text!, userPassword: passwordTextfieldForSingIn.text!)
//                self.defaults.set(emailTextfieldForSingIn.text!, forKey: "userEmail")
//                self.defaults.set(passwordTextfieldForSingIn.text!, forKey: "userPasswort")
//
//            }

//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
//                alertForExistingUser.dismiss(animated: true, completion: nil)
//            }
//
//            alertForExistingUser.addAction(cancelButton)
//            alertForExistingUser.addAction(signInButton)
//
//            alertForExistingUser.addTextField { (emailTextfield) in
//                emailTextfield.placeholder = "Enter Your E-Mail Adress"
//                emailTextfieldForSingIn = emailTextfield
//            }
//            alertForExistingUser.addTextField { (passwortTextfield) in
//                passwortTextfield.placeholder = "Set your Password"
//                passwordTextfieldForSingIn = passwortTextfield
//            }
//
//
//            self.present(alertForExistingUser, animated: true, completion: nil)
//
//        loginButton.isHidden = false
//        loginPasswortTextfield.isHidden = false
//        loginEmailTextfield.isHidden = false


//        var textfieldEmail: UITextField = UITextField()
//        var textfieldPasswort: UITextField = UITextField()
//        let alert = UIAlertController(title: "Create Your Account", message: "Set up your Account", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Create User", style: .default) { (action) in
//
//            Auth.auth().createUser(withEmail: textfieldEmail.text!, password: textfieldPasswort.text!) { (user, error) in
//                if error != nil {
//                    print("Error when signing in \(error!)")
//                }else {
//                    print("Registration Successful")
//                    self.newUser.userId = Auth.auth().currentUser?.uid
//                    self.saveData(user: self.newUser)
//                    self.defaults.set(textfieldEmail.text!, forKey: "userEmail")
//                    self.defaults.set(textfieldPasswort.text!, forKey: "userPasswort")
//                    self.performSegue(withIdentifier: "gotToUserFromCreate", sender: self)
//
//                }
//            }

//        }
//
//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
//                alert.dismiss(animated: true, completion: nil)
//            }
//        alert.addAction(cancelButton)
//        alert.addAction(action)
//
//
//        alert.addTextField { (emailTextfield) in
//            emailTextfield.placeholder = "EnterYour E-Mail Adress"
//            textfieldEmail = emailTextfield
//        }
//        alert.addTextField { (passwortTextfield) in
//            passwortTextfield.placeholder = "Set your Passwort"
//            textfieldPasswort = passwortTextfield
//        }
//
//
//        present(alert, animated: true, completion: nil)
//
//    }
//    }



