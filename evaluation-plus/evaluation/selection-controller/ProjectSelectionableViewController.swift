//
//  ProjectSelectionableViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-27.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class ProjectSelectionableViewController: UITableViewController {
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    var projects = [Project]()
    
    var selectionDelegate: ProjectSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let projectsDictionnary = userDefaults.object(forKey:"projects") as? Data {
            let decodedProjects = NSKeyedUnarchiver.unarchiveObject(with: projectsDictionnary) as! [String: Project]
            
            projects = Array(decodedProjects.values).sorted(by: { s1, s2 in
                return s1.name.lowercased() < s2.name.lowercased()
            })
        }
        
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let stringToShow = "\(projects[indexPath.item].name!)"
        cell.textLabel?.text = stringToShow
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.setProject(selectedItem: projects[indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
