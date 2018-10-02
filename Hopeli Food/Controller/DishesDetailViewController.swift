//
//  DishesDetailViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class DishesDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource  {
    

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    
    var ingredients: Results<Ingredients>?
    
    let realm = try! Realm()
    
    var selectedDish: Dishes? {
        didSet {

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dishNameLabel.text = selectedDish?.dishName
        
            if  let imageFromSelectedDish = selectedDish?.dishImage {
                dishImage.image = UIImage(data: imageFromSelectedDish as Data)
            } else {
                dishImage.image = UIImage(named: "dish-default-image")
        }
    }

    
    
    //    MARK: - Add Picture with ImagePicker
    @IBAction func tapGestureForImageSelection(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            picker.dismiss(animated: true, completion: {
                do {
                    try self.realm.write {
                        self.selectedDish?.dishImage = NSData(data: image.jpegData(compressionQuality: 1)!)
                    }
                }catch {
                    print("Error while deleting \(error)")
                }
                self.dishImage.image = image
            })
        }
    
    }
    
//        MARK: - Table View Methods
    
    
 
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            print("Delete")
//
//            do {
//                try self.realm.write {
//                    self.selectedDish?.ingredients.remove(at: indexPath.row)
//                }
//            }catch {
//                print("Error while deleting \(error)")
//            }
//
//
//            ingredientTableView.reloadData()
//        }
//    }
    
    
    
    //    MARK: - Collection View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedDish?.ingredients.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.collectionViewLabel.text = selectedDish?.ingredients[indexPath.row].ingredientName
        cell.backgroundColor = UIColor.blue
        cell.collectionViewLabel.textColor = UIColor.white
        return cell 
    }
    
  
    
    
       //    MARK: - Back Button Methods
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    

}
