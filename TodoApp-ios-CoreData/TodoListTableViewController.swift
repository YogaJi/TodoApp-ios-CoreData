//
//  TodoListTableViewController.swift
//  TodoApp-ios-CoreData
//
//  Created by Yujia on 2022/3/16.
//

import UIKit
import CoreData
class TodoListTableViewController: UITableViewController {
    //register persistent container
    var persistentContainer: NSPersistentContainer!
    //register the controller that use to manage the results of a Core Data fetch request and to display data
    var fetchedResultsController: NSFetchedResultsController<Todos>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set table view style:
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.rowHeight = 46.0
        self.tableView.separatorColor = UIColor.lightGray
        
        //set persistent container and make request
        let moc = persistentContainer.viewContext
        let request = NSFetchRequest<Todos>(entityName: "Todos")

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //load as fetched
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        //do fetch
        do{
            try fetchedResultsController?.performFetch()
        }catch {
            print("fetch request failed")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//link the table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as!
        TodoTableViewCell
        
        let todo = fetchedResultsController?.object(at: indexPath)
        //set core data to table view cell
        cell.title.text = todo!.title
        cell.date.text = todo!.dates
        //change table view cell style with be selected
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    
        return cell
    }

    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //use persistent container function to delete the row of data
            let context = appDelegate.persistentContainer.viewContext

            context.delete((self.fetchedResultsController?.object(at: indexPath))!)

            appDelegate.saveContext()

        } else if editingStyle == .insert {

        }
    }
     
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //use segue to link to the add todo view controller and register persistent container for the add todo segue
        if let addTodo = segue.destination as? AddTodoViewController {
            addTodo.persistentContainer = persistentContainer
        }
    }
    
}

//MARK: - Fetched Results Controller

extension TodoListTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath
            else{return}
            tableView.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath
                else{return}
            tableView.deleteRows(at: [deleteIndex], with: .fade)
        case .move:
            guard let fromIndex = indexPath,
                  let toIndex = newIndexPath
            else{return}
            tableView.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath
            else{return}
            tableView.reloadRows(at: [updateIndex], with: .automatic)
        @unknown default:
            print("change type unknown")
        }
    }
}
