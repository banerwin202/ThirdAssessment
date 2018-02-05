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
    
    @IBOutlet weak var colorButton: UIBarButtonItem!
    
    
    var fetchResultController = NSFetchedResultsController<PropertyOwners>()
    
    @IBAction func colorButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Choose Theme", message: nil, preferredStyle: .alert)
        let blue = UIAlertAction(title: "Blue", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = UIColor.blue
            UserDefaults.standard.setValue("blue", forKey: "barColor")
        }
        let red = UIAlertAction(title: "Red", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            UserDefaults.standard.setValue("red", forKey: "barColor")
        }
        let green = UIAlertAction(title: "green", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = UIColor.green
            UserDefaults.standard.setValue("green", forKey: "barColor")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(blue)
        alertController.addAction(red)
        alertController.addAction(green)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.dataSource = self
        tableView.delegate = self
        
        
        if UserDefaults.standard.string(forKey: "barColor") == nil {
            navigationController?.navigationBar.barTintColor = UIColor.darkGray
        } else if UserDefaults.standard.string(forKey: "barColor") == "blue" {
            navigationController?.navigationBar.barTintColor = UIColor.blue
        } else if UserDefaults.standard.string(forKey: "barColor") == "red" {
            navigationController?.navigationBar.barTintColor = UIColor.red
        } else if UserDefaults.standard.string(forKey: "barColor") == "green" {
            navigationController?.navigationBar.barTintColor = UIColor.green
        }
        
        
      
        if UserDefaults.standard.bool(forKey: "FirstRun") {
            fetchOwners()
            print("Owner Load")
            
        } else {
            print("Load from Data")
            loadOwners()
            fetchOwners()
            UserDefaults.standard.set(true, forKey: "FirstRun")
        
    }
        

        
        
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

extension OwnersTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = sb.instantiateViewController(withIdentifier: "PropertiesTableViewController") as? PropertiesTableViewController {
            
            vc.selectedOwner = fetchResultController.object(at: indexPath)
            
            navigationController?.pushViewController(vc, animated: true)
            
         
        }
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
    

