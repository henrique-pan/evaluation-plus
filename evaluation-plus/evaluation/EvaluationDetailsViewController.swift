//
//  NewEvaluationViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-20.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class EvaluationDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelFinalGrade: UILabel!
    
    let criterias = ["Criteria 1", "Criteria 2", "Criteria 3", "Criteria 4", "Criteria 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension EvaluationDetailsViewController: GradeDelegate {
    
    func updateGrade(newValue: String) {
        labelFinalGrade.text = newValue
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "evaluationCriteriaCell") as! EvaluationCriteriaTableViewCell
        
        cell.gradeDelegate = self
        
        return cell
    }
}


