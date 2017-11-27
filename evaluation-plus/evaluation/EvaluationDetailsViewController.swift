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
    
    var cells = [String:EvaluationCriteriaTableViewCell]()
    var grades = [String:Int]()
    
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
    
    
}

extension EvaluationDetailsViewController: GradeDelegate {
    
    func updateGrade(newCriteria: String, newValue: Int) {
        grades[newCriteria] = newValue
        
        var sum = 0
        grades.forEach({ grade in
            sum += grade.value
        })
        
        labelFinalGrade.text = "\(sum / grades.count) %"
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


