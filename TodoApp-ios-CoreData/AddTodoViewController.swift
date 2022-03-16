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
    
    @IBOutlet weak var addDate: UITextField!
    
    @IBOutlet weak var addTitle: UITextField!
    
    @IBAction func addTodo(_ sender: Any) {
        
        
        let moc = persistentContainer.viewContext
        
        moc.perform {
            let todo = Todos(context: moc)
            todo.title = self.addTitle.text
            todo.dates = self.addDate.text
            do{
                try moc.save()
            }catch{
                moc.rollback()
            }
        }
    }
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    func createDatePicker(){
        //create toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        //asign toobar
        addDate.inputAccessoryView = toolbar
        addDate.inputView =  datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        
    }
    @objc func donePressed(){
        //text formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        addDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }


}

