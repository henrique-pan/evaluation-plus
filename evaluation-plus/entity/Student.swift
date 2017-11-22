//
//  Student.swift
//  evaluation-plus
//
//  Created by Henrique Nascimento on 2017-11-21.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import Foundation

class Student: NSObject, NSCoding {
    
    var id: Int!
    
    var name: String!
    
    init(id: Int!, name: String!) {
        self.id = id
        self.name = name
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! Int
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(id: id, name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
}
