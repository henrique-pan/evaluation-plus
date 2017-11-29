//
//  Evaluation.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-28.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

class Evaluation: NSObject, NSCoding {
    
    var student: Student!
    var project: Project!
    var grades: [String:Int]!
    
    init(student: Student!, project: Project!, grades: [String:Int]!) {
        self.student = student
        self.project = project
        self.grades = grades
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let student = aDecoder.decodeObject(forKey: "student") as! Student
        let project = aDecoder.decodeObject(forKey: "project") as! Project
        let grades = aDecoder.decodeObject(forKey: "grades") as! [String:Int]
        self.init(student: student, project: project, grades: grades)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(student, forKey: "student")
        aCoder.encode(project, forKey: "project")
        aCoder.encode(grades, forKey: "grades")
    }
}
