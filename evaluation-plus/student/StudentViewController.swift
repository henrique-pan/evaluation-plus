//
//  StudentViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-20.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    //MARK: Search bar
    var searchBar: UISearchBar!
    var searchController: UISearchController!
    private var isSearching = false
    private var filteredStudents = [Student]()
    //MARK: Search bar
    
    //MARK: TableView's properties
    var selectedRow: Int?
    //MARK: TableView's properties
    
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStudents()
        tableView.reloadData()
    }
    
    func loadStudents() {
        //userDefaults.removeObject(forKey: "students")
        if let studentsDictionnary = userDefaults.object(forKey:"students") as? Data {
            let decodedStudents = NSKeyedUnarchiver.unarchiveObject(with: studentsDictionnary) as! [Int: Student]
            
            students = Array(decodedStudents.values).sorted(by: { s1, s2 in
                return s1.name.lowercased() < s2.name.lowercased()
            })

        } else {
            students.removeAll()
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let studentViewController = segue.destination as! NewStudentTableViewController
        if segue.identifier == "addNewStudentSegue" {
            studentViewController.isNewStudent = true
        } else {
            studentViewController.isNewStudent = false
            navigationController?.dismiss(animated: true, completion: nil)
            var studentsToShow: [Student]
            if isSearching {
                studentsToShow = filteredStudents
            } else {
                studentsToShow = students
            }
            
            studentViewController.editingId = studentsToShow[selectedRow!].id
            studentViewController.editingName = studentsToShow[selectedRow!].name
        }
    }
    // MARK: Prepare for segue
    
}

extension StudentViewController {
    // Configs navigation bar
    func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar = searchController.searchBar
        
        searchBar.delegate = self
    }
}

//MARK: Extension TableViewController
extension StudentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredStudents.count
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        var studentsToShow: [Student]
        if isSearching {
            studentsToShow = filteredStudents
        } else {
            studentsToShow = students
        }
        
        cell.textLabel?.text = studentsToShow[indexPath.item].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "editStudentSegue", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var removedStudent: Student
            if isSearching {
                removedStudent = filteredStudents[indexPath.item]
                filteredStudents.remove(at: indexPath.item)
                
                let index = students.index(where: {student in
                    return student.id == removedStudent.id
                })
                students.remove(at: index!)
            } else {
                removedStudent = students.remove(at: indexPath.item)
            }
            
            if let persistentStudents = userDefaults.object(forKey: "students") as? Data {
                var decodedStudents = NSKeyedUnarchiver.unarchiveObject(with: persistentStudents) as! [Int: Student]
                decodedStudents[removedStudent.id] = nil
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedStudents)
                userDefaults.set(encodedData, forKey: "students")
                userDefaults.synchronize()
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

//MARK: Extension SearchBar
extension StudentViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            tableView.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredStudents = students.filter({ student in
                let typedTextLowercased = searchBar.text!.lowercased()
                let studentName = student.name.folding(options: .diacriticInsensitive, locale: .current)
                return studentName.contains(typedTextLowercased)
            })
            tableView.reloadData()
        }
    }
}

