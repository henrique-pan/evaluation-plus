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
    @IBOutlet weak var labelFinalGrade: UILabel!
    
    var grades = [String:Int]()
    var cells = [String:EvaluationCriteriaTableViewCell]()
    var selectedStudent: Student?
    var selectedProject: Project?
    
    let criterias = ["Criteria 1", "Criteria 2", "Criteria 3", "Criteria 4", "Criteria 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        cells = [String:EvaluationCriteriaTableViewCell]()
        grades = [String:Int]()
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
        labelStudent.text = "\(selectedItem.name!) : \(selectedItem.id!)"
    }
    
    func setProject(selectedItem: Project!) {
        selectedProject = selectedItem
        labelProject.text = "\(selectedItem.name!)"
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


