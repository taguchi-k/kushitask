//
//  TaskDao.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation
import RealmSwift
import STV_Extensions

final class TaskDao {

    static let dao = RealmDaoHelper<Task>()

    /// タスクを登録する
    ///
    /// - Parameter title: タイトル
    /// - Returns: タスク
    static func add(title: String) -> Task {

        let object = Task()
        object.id = TaskDao.dao.newId()!
        object.title = title
        object.date = Date().now()

        TaskDao.dao.add(d: object)

        return object
    }

    /// タスクを更新する
    ///
    /// - Parameter model: タスクモデル
    static func update(model: Task) {

        guard let target = dao.findFirst(key: model.id as AnyObject) else {
            return
        }

        let object = Task()
        object.id = target.id
        object.title = model.title
        object.date = Date().now()
        _ = dao.update(d: object)
    }

    /// 該当のタスクを削除する
    ///
    /// - Parameter id: タスクID
    static func delete(id: Int) {
        guard let object = dao.findFirst(key: id as AnyObject) else { return }
        dao.delete(d: object)
    }

    /// タスクを全て削除する
    static func deleteAll() {
        dao.deleteAll()
    }

    /// 該当のタスクを取得する
    ///
    /// - Parameter id: タスクID
    /// - Returns: タスクモデル
    static func findByID(id: Int) -> Task? {
        return dao.findFirst(key: id as AnyObject)
    }

    /// 全てのタスクを取得する
    ///
    /// - Returns: タスクモデルの配列
    static func findAll() -> [Task] {
        let objects = TaskDao.dao
            .findAll()
            .sorted(byKeyPath: Constants.dateKey, ascending: false)
        return objects.map { Task(value: $0) }
    }
}
