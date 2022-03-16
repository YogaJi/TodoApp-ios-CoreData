//
//  ViewController.swift
//  TodoApp-ios-CoreData
//
//  Created by Yujia on 2022/3/16.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    var persistentContainer: NSPersistentContainer!
    
    @IBOutlet weak var addDescription: UITextField!
    @IBOutlet weak var addTitle: UITextField!
    
    @IBAction func addTodo(_ sender: Any) {
        let moc = persistentContainer.viewContext
        
        moc.perform {
            let todo = Todos(context: moc)
            todo.title = self.addTitle.text
            do{
                try moc.save()
            }catch{
                moc.rollback()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

