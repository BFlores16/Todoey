//
//  Category.swift
//  Todoey
//
//  Created by Brando Flores on 12/7/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
