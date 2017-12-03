//
//  EvaluationCriteriaTableViewCell.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

//TableViewCell that represents a criteria
class EvaluationCriteriaTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelSliderValue: UILabel!
    @IBOutlet weak var labelGrade: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    //MARK: Outlets
    
    var criteria: String?
    var existentGrade: Int?
    
    var gradeDelegate: GradeDelegate?
    
    //MARK: Actions
    @IBAction func valueChanged(_ sender: UISlider) {
        self.accessoryType = .checkmark

        let roundedValue: Int
        if existentGrade != nil {
            roundedValue = existentGrade! / 20
            slider.value = Float(roundedValue)
            existentGrade = nil
        } else {
            roundedValue = Int(sender.value)
        }
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
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        gradeDelegate!.updateComment(newCriteria: criteria!, newComment: textFieldComment.text!)
    }
    //MARK: Actions
}
