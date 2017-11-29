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
    
    var students = [Student]()
    var sections = [Project]()
    var evaluations = [Project : [Student : Evaluation]]()
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEvaluations()
        
        tableView.tableFooterView = UIView()
    }

    func loadEvaluations() {
        //userDefaults.removeObject(forKey: "evaluations")
        if let savedEvaluations = userDefaults.object(forKey: "evaluations") as? Data {
            
            let decodedEvaluations = NSKeyedUnarchiver.unarchiveObject(with: savedEvaluations) as! [Project : [Student : Evaluation]]
            evaluations = decodedEvaluations
            sections = Array(decodedEvaluations.keys).sorted(by: { p1, p2 in
                return p1.name < p2.name
            })
            
        } else {
            evaluations.removeAll()
        }
    }
    
}

//MARK: Extension TableViewController
extension EvaluationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students = Array(evaluations[sections[section]]!.keys).sorted(by: {s1, s2 in
            return s1.name < s2.name
        })
        return evaluations[sections[section]]!.count
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = "\(students[indexPath.item].name!) : \(students[indexPath.item].id!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editEvaluationSegue", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let evaluations = userDefaults.object(forKey: "evaluations") as? Data {
                
                var decodedEvaluations = NSKeyedUnarchiver.unarchiveObject(with: evaluations) as! [Project : [Student : Evaluation]]
                let project = sections[indexPath.section]
                students = Array(decodedEvaluations[project]!.keys).sorted(by: {s1, s2 in
                    return s1.name < s2.name
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
