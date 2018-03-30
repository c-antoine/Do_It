//
//  Item.swift
//  SwiftDB
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 Antoine. All rights reserved.
//

import Foundation

class Item: Codable{
    var name: String
    var checked = false
    
    init(name: String) {
        self.name = name
    }
    
}
