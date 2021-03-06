//
//  Project.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

// Entity that represents each Project
class Project: NSObject, NSCoding, NSCopying {
    
    var name: String!
    var projectDescription: String!
    var weight: Int!
    
    // Project constructor
    init(name: String!, projectDescription: String!, weight: Int!) {
        self.name = name
        self.projectDescription = projectDescription
        self.weight = weight
    }
    
    // Serialization to Userdefaults
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let projectDescription = aDecoder.decodeObject(forKey: "projectDescription") as! String
        let weight = aDecoder.decodeObject(forKey: "weight") as! Int
        self.init(name: name, projectDescription: projectDescription, weight: weight)
    }
    
    // Serialization to Userdefaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(projectDescription, forKey: "projectDescription")
        aCoder.encode(weight, forKey: "weight")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Project(name: name, projectDescription: projectDescription, weight: weight)
        return copy
    }
    
}
