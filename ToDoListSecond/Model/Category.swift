//
//  Category.swift
//  ToDoListSecond
//
//  Created by Hongbo Niu on 2018-03-26.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
