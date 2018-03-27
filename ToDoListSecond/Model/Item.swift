//
//  Item.swift
//  ToDoListSecond
//
//  Created by Hongbo Niu on 2018-03-26.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
