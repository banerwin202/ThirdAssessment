//
//  PropertiesTableViewController.swift
//  ThirdAssessment
//
//  Created by Ban Er Win on 02/02/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import CoreData

class PropertiesTableViewController: UIViewController {
    
    var selectedOwner : PropertyOwners?
    var fetchedResultController = NSFetchedResultsController<Property>()
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.rowHeight = 100
        addButton()
//        fetchProperty()
        }
    

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
//    func fetchProperty() {
//        let request = NSFetchRequest<Property>(entityName: "Property")
//
//        let sortName = NSSortDescriptor(key: "name", ascending: true)
//        let sortPrice = NSSortDescriptor(key: "price", ascending: false)
//        let sortLocation = NSSortDescriptor(key: "location", ascending: false)
//
//        request.sortDescriptors = [sortName, sortPrice, sortLocation]
    
//        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.moc, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultController.delegate = self
        
//        do {
//            try fetchedResultController.performFetch()
//            tableView.reloadData()
//        } catch {
//            print("Error")
//        }
//
        
//    }
    
    
    
    func addButton() {
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(sender:)))
        //        let play = UIBarButtonItem(title: "Play", style:  .plain, target: self, action: #selector(playTapped))
        
        navigationItem.rightBarButtonItems = [add]
    }
    
    @objc func addButtonTapped(sender: UIBarButtonItem) {
        //segue to next controller
        
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else {return}
        //        navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        
        vc.selectedOwner2 = selectedOwner
        
        navigationController?.pushViewController(vc, animated: true)
        
        print("AddViewController")
    }


}


extension PropertiesTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedOwner?.hasProperty?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "propertyCell", for: indexPath) as? PropertyTableViewCell else {return UITableViewCell()}
        
        
        if let properties = selectedOwner?.hasProperty?.allObjects as? [Property] {
            let currentProperty = properties[indexPath.row]
            cell.nameLabel.text = currentProperty.name
            cell.priceLabel.text = currentProperty.price
            cell.locationLabel.text = currentProperty.location
        }
        return cell
        
    }
    
}

//extension PropertiesTableViewController : NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//        print("Will Change")
//    }

    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        print("DidChange")
//
//        print("old : ", indexPath)
//        print("new : ", newIndexPath)
//
//        switch type {
//        case .insert:
//            print("Insert")
//            if let new = newIndexPath {
//                tableView.insertRows(at: [new], with: .right)
//            }
//        case .update:
//            print("Update")
//            if let old = indexPath {
//                tableView.reloadRows(at: [old], with: .middle)
//            }
//        case .move:
//            print("Move")
//            if let old = indexPath,
//                let new = newIndexPath {
//
//                tableView.performBatchUpdates({
//                    tableView.moveRow(at: old, to: new)
//                }, completion: { (complete) in
//                    self.tableView.reloadRows(at: [new], with: .none)
//                })
//
//
//            }
//        case .delete:
//            print("Delete")
//            if let old = indexPath {
//                tableView.deleteRows(at: [old], with: .left)
//            }
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//        print("Finish Change")
//    }
//
//}
//
//
//
