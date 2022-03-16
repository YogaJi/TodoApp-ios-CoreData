//
//  TodoListTableViewController.swift
//  TodoApp-ios-CoreData
//
//  Created by Yujia on 2022/3/16.
//

import UIKit
import CoreData
class TodoListTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer!
    //var todo = [Todos]()
    var fetchedResultsController: NSFetchedResultsController<Todos>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moc = persistentContainer.viewContext
        let request = NSFetchRequest<Todos>(entityName: "Todos")

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //load as fetched
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do{
            try fetchedResultsController?.performFetch()
        }catch {
            print("fetch request failed")
        }

    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let request: NSFetchRequest<Todos> = Todos.fetchRequest()
//        let moc = persistentContainer.viewContext
//
//        guard
//            let results = try? moc.fetch(request)
//        else {return}
//
//        todo = results
//
//        tableView.reloadData()
//    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController?.fetchedObjects?.count ?? 0
        //return todo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath)
        let todo = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = todo!.title
        // Configure the cell...
        //let title = todo[indexPath.row].title
        
        //cell.textLabel?.text = title
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
            tableView.deleteRows(at: [deleteIndex], with: .automatic)
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
