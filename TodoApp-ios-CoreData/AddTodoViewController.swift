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
    //when clicking addTodo button, persistent container will save core data through the user input text field
    @IBAction func addTodo(_ sender: Any) {
        
        let moc = persistentContainer.viewContext
        
        moc.perform {
            let todo = Todos(context: moc)
            //add the view data to the core data
            todo.title = self.addTitle.text
            todo.dates = self.addDate.text
            do{
                try moc.save()
            }catch{
                //Removes everything from the undo stack, discards all insertions and deletions, and restores updated objects to their last committed values
                moc.rollback()
            }
        }
    }
    //set data picker for the date time input
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
        
        //create bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        //toolbar add doneButton
        toolbar.setItems([doneButton], animated: true)
        //asign toobar
        addDate.inputAccessoryView = toolbar
        addDate.inputView =  datePicker
        
        //set date picker mode
        datePicker.datePickerMode = .date
        
    }
    //set date time formatter in the view
    @objc func donePressed(){
        //text formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        addDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}

