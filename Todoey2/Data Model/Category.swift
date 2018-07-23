//
//  Category.swift
//  Todoey2
//
//  Created by Saurav Gupta on 22/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
    
}
