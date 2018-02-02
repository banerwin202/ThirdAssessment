//
//  AddViewController.swift
//  ThirdAssessment
//
//  Created by Ban Er Win on 02/02/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    var selectedProperty : Property?
    var selectedOwner2 : PropertyOwners?
    var addMode = true
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(sender:)))
        
        navigationItem.rightBarButtonItems = [done]
        
        
       self.navigationItem.setHidesBackButton(true, animated:true)
        
        if let property = selectedProperty {
            addMode = false
            nameTextField.text = property.name
            priceTextField.text = property.price
            locationTextField.text = property.location
        }
        
    }
        
        
        func doneButton() {
            
      
            
            if let name = nameTextField.text,
                let price = priceTextField.text,
                let location = locationTextField.text,
            name != "",
            price != "",
            location != "" {
                
                if addMode {
                    createProperty(name: name, price: price, location: location)
                } else {
                    updateProperty(name: name, price: price, location: location)
                }
                
               
            }
    
    }
        
        @objc func doneButtonTapped(sender: UIBarButtonItem) {
            
            doneButton()
        
          
            navigationController?.popViewController(animated: true)
            
            print("AddViewController")
        }
    

    

    func updateProperty(name: String, price: String, location: String) {
        guard let property = selectedProperty else {return}
        property.name = name
        property.price = price
        property.location = location
        
        DataController.saveContext()
    }
    
    func createProperty(name: String, price: String, location: String) {
        guard let entityDesc = NSEntityDescription.entity(forEntityName: "Property", in: DataController.moc) else {
            print("Entity Not Found")
            return
        }
        
        let newProperty = Property(entity: entityDesc, insertInto: DataController.moc)
        newProperty.name = name
        newProperty.price = price
        newProperty.location = location
        
        selectedOwner2?.addToHasProperty(newProperty)
        
        DataController.saveContext()
    }

    


}
