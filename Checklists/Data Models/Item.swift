//
//  Item.swift
//  Checklists
//
//  Created by Prince Bharti on 05/08/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
   @objc dynamic var content: String = ""
   @objc dynamic var done: Bool = false
    
}
