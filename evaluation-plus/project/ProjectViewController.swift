//
//  ProjectViewController.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

//ViewController to show all the existent projects
class ProjectViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: Outlets
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    //MARK: Search bar
    var searchBar: UISearchBar!
    var searchController: UISearchController!
    private var isSearching = false
    private var filteredProjects = [Project]()
    //MARK: Search bar
    
    //MARK: TableView's properties
    var selectedRow: Int?
    //MARK: TableView's properties
    
    var projects = [Project]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProjects()
        tableView.reloadData()
    }
    
    func loadProjects() {
        if let projectsDictionnary = userDefaults.object(forKey:"projects") as? Data {
            let decodedProjects = NSKeyedUnarchiver.unarchiveObject(with: projectsDictionnary) as! [String: Project]
            
            projects = Array(decodedProjects.values).sorted(by: { s1, s2 in
                return s1.name.lowercased() < s2.name.lowercased()
            })
            
        } else {
            projects.removeAll()
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let projectViewController = segue.destination as! NewProjectTableViewController
        if segue.identifier == "addNewProjectSegue" {
            projectViewController.isNewProject = true
        } else {
            projectViewController.isNewProject = false
            navigationController?.dismiss(animated: true, completion: nil)
            var projectsToShow: [Project]
            if isSearching {
                projectsToShow = filteredProjects
            } else {
                projectsToShow = projects
            }
            
            projectViewController.editingName = projectsToShow[selectedRow!].name
            projectViewController.editingDescription = projectsToShow[selectedRow!].projectDescription
            projectViewController.editingWeight = projectsToShow[selectedRow!].weight
        }
    }
    // MARK: Prepare for segue
    
}

extension ProjectViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Configs navigation bar
    func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar = searchController.searchBar
        
        // Customized Search Bar
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            textfield.tintColor = UIColor(red: 201/255, green: 168/255, blue: 89/255, alpha: 1.0)
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        // Customized Search Bar
        
        searchBar.delegate = self
    }
}

//MARK: Extension TableViewController
extension ProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredProjects.count
        } else {
            return projects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        var projectsToShow: [Project]
        if isSearching {
            projectsToShow = filteredProjects
        } else {
            projectsToShow = projects
        }
        
        cell.textLabel?.text = projectsToShow[indexPath.item].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "editProjectSegue", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var removedProject: Project
            if isSearching {
                removedProject = filteredProjects[indexPath.item]
                filteredProjects.remove(at: indexPath.item)
                
                let index = projects.index(where: { project in
                    return project.name == removedProject.name
                })
                projects.remove(at: index!)
            } else {
                removedProject = projects.remove(at: indexPath.item)
            }
            
            if let projects = userDefaults.object(forKey: "projects") as? Data {
                var decodedProjects = NSKeyedUnarchiver.unarchiveObject(with: projects) as! [String: Project]
                decodedProjects[removedProject.name] = nil
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedProjects)
                userDefaults.set(encodedData, forKey: "projects")
                userDefaults.synchronize()
            }            
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

//MARK: Extension SearchBar
extension ProjectViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            tableView.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredProjects = projects.filter({ project in
                let typedTextLowercased = searchBar.text!.lowercased()
                let projectName = project.name.folding(options: .diacriticInsensitive, locale: .current)
                return projectName.contains(typedTextLowercased)
            })
            tableView.reloadData()
        }
    }
}

