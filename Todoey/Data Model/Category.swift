//
//  Category.swift
//  Todoey
//
//  Created by Brandi D Gremillion on 8/1/18.
//  Copyright © 2018 Gremillion Consulting. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //Create a constant called items which is a list of Item objects initialized empty
    //Defines the forward relationship from Category to Items
    let items = List<Item>()
}
