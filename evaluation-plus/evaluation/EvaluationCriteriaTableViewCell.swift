//
//  EvaluationCriteriaTableViewCell.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-26.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class EvaluationCriteriaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelSliderValue: UILabel!
    @IBOutlet weak var labelGrade: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    
    var criteria: String?
    
    var gradeDelegate: GradeDelegate?
    
    @IBAction func valueChanged(_ sender: UISlider) {
        self.accessoryType = .checkmark
        
        let roundedValue = Int(sender.value)
        switch roundedValue {
        case 0:
            labelSliderValue.text = "Unacceptable"
        case 1:
            labelSliderValue.text = "Very Bad"
        case 2:
            labelSliderValue.text = "Bad"
        case 3:
            labelSliderValue.text = "Good"
        case 4:
            labelSliderValue.text = "Very Good"
        case 5:
            labelSliderValue.text = "Excellent"
        default:
            labelSliderValue.text = "No Value"
            labelGrade.text = "No Value"
        }
        labelGrade.text = "\(roundedValue * 20) %"
        gradeDelegate!.updateGrade(newCriteria: criteria!, newValue: (roundedValue * 20))
    }
}
