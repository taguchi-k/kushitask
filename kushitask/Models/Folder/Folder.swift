//
//  Folder.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation

import RealmSwift

final class Folder: Object {

    dynamic var id = 0
    dynamic var name = ""
    dynamic var date = Date()
    let tasks = List<Task>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
