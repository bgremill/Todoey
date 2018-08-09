//
//  Item.swift
//  Todoey
//
//  Created by Brandi D Gremillion on 8/1/18.
//  Copyright © 2018 Gremillion Consulting. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?

    //Defines the inverse relationship of the child items to the parent category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")    
}
