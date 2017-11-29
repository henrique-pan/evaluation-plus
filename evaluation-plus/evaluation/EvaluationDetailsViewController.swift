//
//  NewEvaluationViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-20.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class EvaluationDetailsViewController: UIViewController {
    
    @IBOutlet weak var labelStudent: UILabel!
    @IBOutlet weak var labelProject: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var labelFinalGrade: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var grades = [String:Int]()
    var cells = [String:EvaluationCriteriaTableViewCell]()
    var selectedStudent: Student?
    var selectedProject: Project?
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    let criterias = ["Criteria 1", "Criteria 2", "Criteria 3", "Criteria 4", "Criteria 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableViewHeader.isHidden = true
        saveButton.isEnabled = false
        
        tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if grades.count < 5 {
            let alert = UIAlertController(title: "Attention",
                                          message: "Please evaluate all the criterias!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let evaluation = Evaluation(student: selectedStudent!, project: selectedProject, grades: grades)
            
            var encodedData: Data!
            
            if let evaluations = userDefaults.object(forKey: "evaluations") as? Data {
                var decodedEvaluations = NSKeyedUnarchiver.unarchiveObject(with: evaluations) as! [Project : [Student : Evaluation]]
                decodedEvaluations[selectedProject!]![selectedStudent!] = evaluation
                encodedData = NSKeyedArchiver.archivedData(withRootObject: decodedEvaluations)
            } else {
                var evaluations = [Project : [Student : Evaluation]]()
                evaluations[selectedProject!] = [selectedStudent!:evaluation]
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: evaluations)
            }
            
            userDefaults.set(encodedData, forKey: "evaluations")
            userDefaults.synchronize()
            
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
            cells = [String:EvaluationCriteriaTableViewCell]()
            grades = [String:Int]()
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        cells = [String:EvaluationCriteriaTableViewCell]()
        grades = [String:Int]()
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "chooseStudentSegue" {
           let chooseViewController = segue.destination as! StudentSelectionableViewController
           chooseViewController.selectionDelegate = self
        } else if segue.identifier == "chooseProjectSegue" {
            let chooseViewController = segue.destination as! ProjectSelectionableViewController
            chooseViewController.selectionDelegate = self
        }
    }
    // MARK: Prepare for segue
    
}

extension EvaluationDetailsViewController: GradeDelegate, StudentSelectionDelegate, ProjectSelectionDelegate {
    
    func updateGrade(newCriteria: String, newValue: Int) {
        grades[newCriteria] = newValue
        
        var sum = 0
        grades.forEach({ grade in
            sum += grade.value
        })
        
        labelFinalGrade.text = "\(sum / grades.count) %"
    }
    
    func setStudent(selectedItem: Student!) {
        selectedStudent = selectedItem
        labelStudent.textColor = UIColor.black
        labelStudent.text = "\(selectedItem.name!) : \(selectedItem.id!)"
        if selectedProject != nil && selectedStudent != nil {
            tableView.isHidden = false
            tableViewHeader.isHidden = false
            saveButton.isEnabled = true
        }
    }
    
    func setProject(selectedItem: Project!) {
        selectedProject = selectedItem
        labelProject.textColor = UIColor.black
        labelProject.text = "\(selectedItem.name!)"
        if selectedProject != nil && selectedStudent != nil {
            tableView.isHidden = false
            tableViewHeader.isHidden = false
            saveButton.isEnabled = true
        }
    }
    
}

extension EvaluationDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return criterias.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return criterias[section]
    }    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: EvaluationCriteriaTableViewCell?
        cell = cells[criterias[indexPath.section]]
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "evaluationCriteriaCell") as? EvaluationCriteriaTableViewCell
            cell?.gradeDelegate = self            
            cells[criterias[indexPath.section]] = cell
            cell?.criteria = criterias[indexPath.section]
        }
        
        return cell!
    }
}


