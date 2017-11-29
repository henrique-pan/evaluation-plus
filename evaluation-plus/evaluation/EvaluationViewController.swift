//
//  ViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-20.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class EvaluationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [Int]()
    var sections = [String]()
    var evaluations = [String : [Int : Evaluation]]()
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    //MARK: TableView's properties
    var selectedRow: Int?
    var selectedSection: Int?
    //MARK: TableView's properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvaluations()
        tableView.reloadData()
    }
    
    func loadEvaluations() {
        //userDefaults.removeObject(forKey: "evaluations")
        if let savedEvaluations = userDefaults.object(forKey: "evaluations") as? Data {            
            let decodedEvaluations = NSKeyedUnarchiver.unarchiveObject(with: savedEvaluations) as! [String : [Int : Evaluation]]
            evaluations = decodedEvaluations
            sections = Array(decodedEvaluations.keys).sorted(by: { p1, p2 in
                return p1 < p2
            })
        } else {
            evaluations.removeAll()
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let detailsViewController = segue.destination as! EvaluationDetailsViewController
        if segue.identifier == "addEvaluationSegue" {
            detailsViewController.isNewEvaluation = true
        } else {
            detailsViewController.isNewEvaluation = false
            
            let selectedEvaluations = evaluations[sections[selectedSection!]]
            students = Array(selectedEvaluations!.keys).sorted(by: {s1, s2 in
                return s1 < s2
            })
            
            detailsViewController.selectedStudent = selectedEvaluations?[students[selectedRow!]]?.student
            detailsViewController.selectedProject = selectedEvaluations?[students[selectedRow!]]?.project
            detailsViewController.grades = (selectedEvaluations?[students[selectedRow!]]?.grades)!
        }
    }
    // MARK: Prepare for segue
    
}

//MARK: Extension TableViewController
extension EvaluationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students = Array(evaluations[sections[section]]!.keys).sorted(by: {s1, s2 in
            return s1 < s2
        })
        return evaluations[sections[section]]!.count
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator        
        
        let evaluation = evaluations[sections[indexPath.section]]![students[indexPath.item]]
        
        cell.textLabel?.text = "\(evaluation!.student.name!) : \(evaluation!.student.id!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedSection = indexPath.section
        performSegue(withIdentifier: "editEvaluationSegue", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let evaluations = userDefaults.object(forKey: "evaluations") as? Data {
                
                var decodedEvaluations = NSKeyedUnarchiver.unarchiveObject(with: evaluations) as! [String : [Int : Evaluation]]
                let project = sections[indexPath.section]
                students = Array(decodedEvaluations[project]!.keys).sorted(by: {s1, s2 in
                    return s1 < s2
                })
                decodedEvaluations[project]![students[indexPath.item]] = nil
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedEvaluations)
                userDefaults.set(encodedData, forKey: "evaluations")
                userDefaults.synchronize()
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}
