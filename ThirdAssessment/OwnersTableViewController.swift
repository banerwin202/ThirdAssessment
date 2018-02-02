//
//  ViewController.swift
//  ThirdAssessment - Er Win
//
//  Created by Ban Er Win on 02/02/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import CoreData

class OwnersTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    

    
    var fetchResultController = NSFetchedResultsController<PropertyOwners>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.dataSource = self
//        tableView.delegate = self
        
        loadOwners()
        fetchOwners()
        
        
        
    }
    
    func loadOwners() {
        let ownerArray = ["Sam", "Josh", "Gareth", "Newt", "Thomas", "Abu", "Dave", "Melvin", "Nicholas","Alice"]
        
        
        for item in ownerArray {
                   guard let owners = NSEntityDescription.insertNewObject(forEntityName: "PropertyOwners", into:
                    DataController.moc) as? PropertyOwners else {return}
        
          owners.name = item
        }
        
        tableView.reloadData()
        DataController.saveContext()
        
        
        
    }

    func fetchOwners() {
        let request = NSFetchRequest<PropertyOwners>(entityName: "PropertyOwners")
        let sortOwner = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortOwner]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            tableView.reloadData()
        } catch {
            print("Error Fetching Data")
        }

    }
    
}

extension OwnersTableViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentOwner = fetchResultController.object(at: indexPath)
        
        cell.textLabel?.text = currentOwner.name
        
        return cell
    }
    
}

extension OwnersTableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Did Change")
        
        print("old : ", indexPath)
        print("new : ", newIndexPath)
        
        switch type {
        case .insert:
            print("Insert")
            if let new = newIndexPath {
                tableView.insertRows(at: [new], with: .right)
            }
        case .update:
            print("Update")
            if let old = indexPath {
                tableView.reloadRows(at: [old], with: .middle)
            }
        case .move:
            print("Move")
            if let old = indexPath,
                let new = newIndexPath {
                
                tableView.performBatchUpdates({
                    tableView.moveRow(at: old, to: new)
                }, completion: { (complete) in
                    self.tableView.reloadRows(at: [new], with: .none)
                })
                
            }
        case .delete:
            print("Delete")
            if let old = indexPath {
                tableView.deleteRows(at: [old], with: .left)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print("Finish Change")
    }
    
}
    

