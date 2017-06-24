//
//  FolderDao.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation

import RealmSwift
import STV_Extensions

final class FolderDao {

    static let dao = RealmDaoHelper<Folder>()

    /// フォルダを登録する
    ///
    /// - Parameter name: フォルダ名
    static func add(name: String) {

        let object = Folder()
        object.id = FolderDao.dao.newId()!
        object.name = name
        object.date = Date().now()

        FolderDao.dao.add(d: object)
    }

    /// フォルダを更新する
    ///
    /// - Parameter model: フォルダモデル
    static func update(model: Folder) {

        guard let target = dao.findFirst(key: model.id as AnyObject) else {
            return
        }

        let object = Folder()
        object.id = target.id
        object.name = model.name
        object.date = Date().now()
        model.tasks.forEach {
            object.tasks.append($0)
        }

        _ = dao.update(d: object)
    }

    /// 該当のフォルダを削除する
    ///
    /// - Parameter id: フォルダID
    static func delete(id: Int) {
        guard let object = dao.findFirst(key: id as AnyObject) else { return }

        // フォルダに紐付いたタスクも削除する
        object.tasks.forEach { TaskDao.delete(id: $0.id) }

        dao.delete(d: object)
    }

    /// フォルダを全て削除する
    static func deleteAll() {
        dao.deleteAll()
        // タスクも削除する
        TaskDao.deleteAll()
    }

    /// IDからフォルダを取得する
    ///
    /// - Parameter id: フォルダID
    /// - Returns: フォルダモデル
    static func findByID(id: Int) -> Folder? {
        return dao.findFirst(key: id as AnyObject)
    }

    /// 全てのフォルダを取得する
    ///
    /// - Returns: フォルダモデルの配列
    static func findAll() -> [Folder] {
        let objects = FolderDao.dao
            .findAll()
            .sorted(byKeyPath: Constants.dateKey, ascending: false)
        return objects.map { Folder(value: $0) }
    }
}
