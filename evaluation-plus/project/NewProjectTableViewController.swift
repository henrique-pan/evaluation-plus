//
//  NewProjectTableViewController.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

//TableViewController that shows project's details
class NewProjectTableViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var sliderWeight: UISlider!
    //MARK: Outlets
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    var isNewProject: Bool = false
    
    //Editing variables
    var editingName: String?
    var editingDescription: String?
    var editingWeight: Int?
    //Editing variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Set title
        if isNewProject {
            self.title = "Add Project"
        } else {
            self.title = "Edit Project"
            tableView.allowsSelection = false
            textFieldName.isEnabled = false
            textFieldName.text = "\(editingName!)"
            textFieldDescription.text = editingDescription
            sliderWeight.value = Float(editingWeight!)
            labelWeight.textColor = UIColor.black
            labelWeight.text = "\(editingWeight! * 10)%"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNewProject {
            textFieldName.becomeFirstResponder()
        } else {
            textFieldDescription.becomeFirstResponder()
        }
    }
    
    //MARK: Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if editingWeight == nil {
            let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""),
                                          message: "Please, set the weight",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if !textFieldName.text!.isEmpty && !textFieldDescription.text!.isEmpty {
                let name = textFieldName.text!
                let projectDescription = textFieldDescription.text!
                let project = Project(name: name, projectDescription: projectDescription, weight: editingWeight)
                
                var encodedData: Data!
                
                if let projects = userDefaults.object(forKey: "projects") as? Data {
                    var decodedProjects = NSKeyedUnarchiver.unarchiveObject(with: projects) as! [String: Project]
                    decodedProjects[name] = project
                    
                    encodedData = NSKeyedArchiver.archivedData(withRootObject: decodedProjects)
                } else {
                    var projects = [String: Project]()
                    projects[name] = project
                    
                    encodedData = NSKeyedArchiver.archivedData(withRootObject: projects)
                }
                
                userDefaults.set(encodedData, forKey: "projects")
                userDefaults.synchronize()
                
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""),
                                              message: "Please, enter the name and the description correctly",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        editingWeight = Int(sender.value)
        labelWeight.textColor = UIColor.black
        labelWeight.text = "\(editingWeight! * 10)%"
    }
    //MARK: Actions
}

