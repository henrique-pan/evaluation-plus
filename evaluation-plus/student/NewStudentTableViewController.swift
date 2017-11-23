//
//  NewStudentTableViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-20.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class NewStudentTableViewController: UITableViewController {

    @IBOutlet weak var textFieldId: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    var isNewStudent: Bool = false
    
    //Editing variables
    var editingId: Int?
    var editingName: String?    
    //Editing variables    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Set title
        if isNewStudent {
            self.title = "Add Student"
        } else {
            self.title = "Edit Student"
            tableView.allowsSelection = false
            textFieldId.isEnabled = false
            textFieldId.text = "\(editingId!)"
            textFieldName.text = editingName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNewStudent {
            textFieldId.becomeFirstResponder()
        } else {
            textFieldName.becomeFirstResponder()
        }
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if !textFieldId.text!.isEmpty && !textFieldName.text!.isEmpty {
            if let id = Int(textFieldId.text!) {
                let name = textFieldName.text!
                let student = Student(id: id, name: name)
                
                var encodedData: Data!
                
                if let students = userDefaults.object(forKey: "students") as? Data {
                    var decodedStudents = NSKeyedUnarchiver.unarchiveObject(with: students) as! [Int: Student]
                    decodedStudents[id] = student
                    
                    encodedData = NSKeyedArchiver.archivedData(withRootObject: students)
                } else {
                    var students = [Int: Student]()
                    students[id] = student
                    
                    encodedData = NSKeyedArchiver.archivedData(withRootObject: students)
                }
                
                userDefaults.set(encodedData, forKey: "students")
                userDefaults.synchronize()
                
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""),
                                              message: "Please, the code should be a number",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""),
                                          message: "Please, enter the code and the name correctly",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

