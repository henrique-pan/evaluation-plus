//
//  Student.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-19.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

// Entity that represents each Student
class Student: NSObject, NSCoding, NSCopying {
    
    var id: Int!
    var name: String!
    
    // Student constructor
    init(id: Int!, name: String!) {
        self.id = id
        self.name = name
    }
    
    // Serialization to Userdefaults
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! Int
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(id: id, name: name)
    }
    
    // Serialization to Userdefaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Student(id: id, name: name)
        return copy
    }

}

