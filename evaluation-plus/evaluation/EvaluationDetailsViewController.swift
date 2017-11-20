//
//  NewEvaluationViewController.swift
//  evaluation-plus
//
//  Created by eleves on 2017-11-20.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class EvaluationDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


