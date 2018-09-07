//
//  DishesDetailViewController.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class DishesDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    
    @IBOutlet weak var dishImage: UIImageView!
    
   
    let realm = try! Realm()
    
    var selectedDish: Dishes? {
        didSet {
//            loadDishesData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
            if  let imageFromSelectedDish = selectedDish?.dishImage {
                dishImage.image = UIImage(data: imageFromSelectedDish as! Data)
            } else {
                dishImage.image = UIImage(named: "dish-default-image")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        title = selectedDish?.dishName
    }
    
    //    MARK: - Data Model
    
    
    
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                
                do {
                    try self.realm.write {
                        self.selectedDish?.dishImage = NSData(data: UIImageJPEGRepresentation(image, 1)!)
                    }
                }catch {
                    print("Error while deleting \(error)")
                }
                self.dishImage.image = image
            })
        }
    
    
    }
    
    
    
    
    
    
    
    
    
    

}
