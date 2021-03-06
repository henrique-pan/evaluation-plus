//
//  Evaluation.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

// Entity that represents each Evaluation
class Evaluation: NSObject, NSCoding {
    
    var student: Student!
    var project: Project!
    var grades: [String:Int]!
    var comments: [String:String]!
    
    // Evaluation constructor
    init(student: Student!, project: Project!, grades: [String:Int]!, comments: [String:String]!) {
        self.student = student
        self.project = project
        self.grades = grades
        self.comments = comments
    }
    
    // Serialization to Userdefaults
    required convenience init(coder aDecoder: NSCoder) {
        let student = aDecoder.decodeObject(forKey: "student") as! Student
        let project = aDecoder.decodeObject(forKey: "project") as! Project
        let grades = aDecoder.decodeObject(forKey: "grades") as! [String:Int]
        let comments = aDecoder.decodeObject(forKey: "comments") as! [String:String]
        self.init(student: student, project: project, grades: grades, comments: comments)
    }
    
    // Serialization to Userdefaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(student, forKey: "student")
        aCoder.encode(project, forKey: "project")
        aCoder.encode(grades, forKey: "grades")
        aCoder.encode(comments, forKey: "comments")
    }
}
