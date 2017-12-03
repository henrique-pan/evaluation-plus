//
//  StudentSelectionTableViewController.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

// Controller to select the student
class StudentSelectionableViewController: UITableViewController {
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    var students = [Student]()
    
    var selectionDelegate: StudentSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load students
        if let studentsDictionnary = userDefaults.object(forKey:"students") as? Data {
            let decodedStudents = NSKeyedUnarchiver.unarchiveObject(with: studentsDictionnary) as! [Int: Student]
            
            students = Array(decodedStudents.values).sorted(by: { s1, s2 in
                return s1.name.lowercased() < s2.name.lowercased()
            })
        }
        
        // Excludes empty lines
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func unwindCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseStudentCell")
        
        let stringToShow = "\(students[indexPath.item].name!) : \(students[indexPath.item].id!)"
        cell?.textLabel?.text = stringToShow        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.setStudent(selectedItem: students[indexPath.item])
        self.navigationController?.popViewController(animated: true)        
    }
    //MARK: TableView methods
    
}
