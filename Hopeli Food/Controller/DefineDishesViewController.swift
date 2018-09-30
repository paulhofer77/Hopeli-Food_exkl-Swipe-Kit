//
//  DefineDishesViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 09.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class DefineDishesViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var ingredientsTableView: UITableView!
    
    let realm = try! Realm()
    var dishes: Results<Dishes>?
    let newDish = Dishes()
    var ingredients: Results<Ingredients>?
    var resultArray: [String] = []

    
    var selectedUser: User? {
        didSet {
            loadDishes()
            loadIngredients()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dishImageView.isHidden = true
        defineDishSummaryStep1Label.isHidden = true
        ingredientsTableView.isHidden = true

    }

    func loadDishes() {
        dishes = selectedUser?.dishes.sorted(byKeyPath: "dishTimestamp", ascending: true)
    }
    
    func loadIngredients(){
        ingredients = realm.objects(Ingredients.self)
        
    }
    
    
    
    @IBOutlet weak var stepOverviewLabel: UILabel!
    
    @IBOutlet weak var defineDishSummaryStep1Label: UILabel!
    
    @IBOutlet weak var dishNameTextfield: UITextField!
    

  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        do {
            try self.realm.write {
                self.newDish.dishName = dishNameTextfield.text!
                self.selectedUser?.dishes.append(newDish)
                self.newDish.users.append(selectedUser!)
            }
        }catch {
            print("Couldn´t Save Category: \(error)")
        }
        
        defineDishSummaryStep1Label.text = dishNameTextfield.text
        defineDishSummaryStep1Label.isHidden = false
        dishNameTextfield.isHidden = true
        dishImageView.isHidden = false
        stepOverviewLabel.text = "Step 2: Select an Image"
        
        return true
    }
 
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //   MARK: - Dish Image Methods
    @IBOutlet weak var dishImageView: UIImageView!
    
    @IBAction func defineDishImage(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        self.stepOverviewLabel.text = "Step 3: Select the Ingredients"
        self.ingredientsTableView.isHidden = false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            picker.dismiss(animated: true, completion: {
                
                do {
                    try self.realm.write {
                        self.newDish.dishImage = NSData(data: image.jpegData(compressionQuality: 1)!)
                    }
                }catch {
                    print("Error while saving \(error)")
                }
                self.dishImageView.image = image
                self.stepOverviewLabel.text = "Step 3: Select the Ingredients"
                self.ingredientsTableView.isHidden = false
            })
        }
        
    }

}

//MARK: - Ingredient Table View Methods
extension DefineDishesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ingredients?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ingredientForCell = ingredients![indexPath.row]
  
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
        cell.ingredientLabel.text = ingredientForCell.ingredientName
        
        let checkForIngredient = newDish.ingredients.index(of: ingredientForCell)
            if checkForIngredient != nil {
                cell.accessoryType = .checkmark
            } else if checkForIngredient == nil {
                cell.accessoryType = .none
            }
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let selectedIngredient = ingredients?[indexPath.row] {
    
            if resultArray.count == 0 {
                do {
                    try realm.write {
                        newDish.ingredients.append(selectedIngredient)
                        selectedIngredient.dishes.append(newDish)
                        resultArray.append(selectedIngredient.ingredientName)
                    }
                } catch {
                    print("error updating data: \(error)")
                }
            } else if resultArray.count >= 0 {
                let checkForIngredidient = resultArray.contains(selectedIngredient.ingredientName)
                    if checkForIngredidient == false {
                        do {
                            try realm.write {
                                newDish.ingredients.append(selectedIngredient)
                                selectedIngredient.dishes.append(newDish)
                                resultArray.append(selectedIngredient.ingredientName)
                            }
                        } catch {
                            print("error updating data: \(error)")
                        }
                    } else if checkForIngredidient == true {
                        
                        do {
                            try realm.write {
                                if let checkForIngredientDelete = newDish.ingredients.index(of: selectedIngredient){
                                    newDish.ingredients.remove(at: checkForIngredientDelete)
                                }
                                if let checkForDishDelete = selectedIngredient.dishes.index(of: newDish) {
                                    selectedIngredient.dishes.remove(at: checkForDishDelete)
                                }
                                if let checkForArryDelete = resultArray.index(of: selectedIngredient.ingredientName) {
                                    resultArray.remove(at: checkForArryDelete)
                                }
                                
                            }
                        } catch {
                            print("error updating data: \(error)")
                        }
                        
                    }
                }
            
            }
    
        ingredientsTableView.reloadData()
        ingredientsTableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    
    
    
}



