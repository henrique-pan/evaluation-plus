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
    
    var students = [(key: Int, value:Student)]()
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.tableFooterView = UIView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvaluations()
        tableView.reloadData()
    }
    
    func loadEvaluations() {
        //userDefaults.removeObject(forKey: "projects")
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
            sortStudents(evaluations: selectedEvaluations)
            
            detailsViewController.selectedStudent = selectedEvaluations?[students[selectedRow!].key]?.student
            detailsViewController.selectedProject = selectedEvaluations?[students[selectedRow!].key]?.project
            detailsViewController.grades = (selectedEvaluations?[students[selectedRow!].key]?.grades)!
            detailsViewController.comments = (selectedEvaluations?[students[selectedRow!].key]?.comments)!
        }
    }
    // MARK: Prepare for segue
    
    func sortStudents(evaluations: [Int : Evaluation]!) {
        students.removeAll()
        
        let studentIds = Array(evaluations!.keys)
        for id in studentIds {
            students.append((key:id, value: evaluations![id]!.student))
        }
        
        let tempStds = students.sorted(by: { t1, t2 in
            return t1.value.name! < t2.value.name
        })
        
        students = tempStds
    }
    
}

//MARK: Extension TableViewController
extension EvaluationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluations[sections[section]]!.count
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.backgroundView?.backgroundColor = UIColor(red: 201/255, green: 168/255, blue: 89/255, alpha: 1.0)
    }
    // UIColor(red: 201/255, green: 168/255, blue: 89/255, alpha: 1.0)

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator        
        
        let project = sections[indexPath.section]
        let stds = evaluations[project]!
        sortStudents(evaluations: stds)
        
        let evaluation = evaluations[sections[indexPath.section]]![students[indexPath.item].key]
        
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
                var shouldRemoveSection = false
                if decodedEvaluations[project]!.count <= 1 {
                    decodedEvaluations.removeValue(forKey: project)
                    shouldRemoveSection = true
                } else {
                    sortStudents(evaluations: decodedEvaluations[project]!)
                    decodedEvaluations[project]![students[indexPath.item].key] = nil
                }
                sections = Array(decodedEvaluations.keys).sorted(by: { p1, p2 in
                    return p1 < p2
                })
                
                self.evaluations = decodedEvaluations
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedEvaluations)
                userDefaults.set(encodedData, forKey: "evaluations")
                userDefaults.synchronize()
                
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                if shouldRemoveSection {
                    self.tableView.deleteSections([indexPath.section], with: .automatic)
                }
                self.tableView.endUpdates()
            }
            
           
        }
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
