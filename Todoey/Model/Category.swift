//
//  Category.swift
//  Todoey
//
//  Created by Brando Flores on 12/7/20.
//

import Foundation
import RealmSwift

class Category: Object {
    // dynamic means changes are monitoring changes during runtime
    @objc dynamic var name : String = ""
    @objc dynamic var cellColor: String?
    let items = List<Item>()
}
