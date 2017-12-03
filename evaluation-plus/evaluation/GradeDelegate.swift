//
//  GradeDelegate.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

// Delegate protocol to update the evaluations' grades and comments
protocol GradeDelegate {
    
    func updateGrade(newCriteria: String, newValue: Int)
    func updateComment(newCriteria: String, newComment: String)
    
}
