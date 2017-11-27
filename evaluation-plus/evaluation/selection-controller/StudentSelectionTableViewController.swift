//
//  StudentSelectionTableViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-27.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class StudentSelectionableViewController: UITableViewController {
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    var students = [Student]()
    
    var selectionDelegate: StudentSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let studentsDictionnary = userDefaults.object(forKey:"students") as? Data {
            let decodedStudents = NSKeyedUnarchiver.unarchiveObject(with: studentsDictionnary) as! [Int: Student]
            
            students = Array(decodedStudents.values).sorted(by: { s1, s2 in
                return s1.name.lowercased() < s2.name.lowercased()
            })
        }
        
        tableView.tableFooterView = UIView()
    }
    
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
    
    @IBAction func unwindCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
