//
//  Item.swift
//  Todoey
//
//  Created by Brandi D Gremillion on 7/12/18.
//  Copyright © 2018 Gremillion Consulting. All rights reserved.
//

import Foundation

//Added Codable when switched from User Defaults to NSCoder
//Could have used Encodable, Decodable instead of just Codable
class Item: Codable {
    
    var title: String = ""
    var done: Bool = false
    
}

