//
//  Item.swift
//  Todoey2
//
//  Created by Saurav Gupta on 22/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
   
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
