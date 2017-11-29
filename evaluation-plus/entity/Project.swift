//
//  Project.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-21.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

class Project: NSObject, NSCoding, NSCopying {
    
    var name: String!
    
    var projectDescription: String!
    
    init(name: String!, projectDescription: String!) {
        self.name = name
        self.projectDescription = projectDescription
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let projectDescription = aDecoder.decodeObject(forKey: "projectDescription") as! String
        self.init(name: name, projectDescription: projectDescription)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(projectDescription, forKey: "projectDescription")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Project(name: name, projectDescription: projectDescription)
        return copy
    }
    
}
