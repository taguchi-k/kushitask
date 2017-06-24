//
//  FolderDaoTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
@testable import kushitask

class FolderDaoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        FolderDao.deleteAll()
    }

    override func tearDown() {
        FolderDao.deleteAll()
        super.tearDown()
    }

    /// 登録できるか
    func testAddFoloder() {
        FolderDao.add(name: "フォルダ名")
        verifyFolder(id: 1, name: "フォルダ名")
    }

    /// 変更できるか
    func testUpdateFolder() {

        // Setup
        FolderDao.add(name: "フォルダ名")

        // Exercise
        let result = FolderDao.findAll().first

        result?.name = "フォルダ名更新"
        let task = Task()
        result?.tasks.append(task)

        FolderDao.update(model: result!)

        // Verify
        verifyFolder(id: 1, name: "フォルダ名更新", task: task)
    }

    /// 削除できるか（タスクも消える？）
    func testDeleteFoloder() {

        FolderDao.add(name: "フォルダ名")

        let result = FolderDao.findAll().first

        result?.name = "フォルダ名更新"
        let task = Task()
        result?.tasks.append(task)

        FolderDao.update(model: result!)

        FolderDao.delete(id: 1)
        verifyCount(count: 0)

        let tasks = TaskDao.findAll()
        XCTAssertEqual(tasks.count, 0)
    }

    /// フォルダが取得できるか
    func testFindAllFolder() {

        FolderDao.add(name: "フォルダ名1")
        FolderDao.add(name: "フォルダ名2")
        FolderDao.add(name: "フォルダ名3")

        verifyCount(count: 3)
    }

    /// フォルダが更新日の降順で取得されるか
    func testFindAllFolder_ForOrder() {

        FolderDao.add(name: "フォルダ名1")
        sleep(1)
        FolderDao.add(name: "フォルダ名2")
        sleep(1)
        FolderDao.add(name: "フォルダ名3")

        let result = FolderDao.findAll()

        XCTAssertEqual(result[0].name, "フォルダ名3")
        XCTAssertEqual(result[1].name, "フォルダ名2")
        XCTAssertEqual(result[2].name, "フォルダ名1")
    }

    /// 該当のフォルダを取得できるか
    func testFindByIdFolder() {

        FolderDao.add(name: "フォルダ名1")
        FolderDao.add(name: "フォルダ名2")
        FolderDao.add(name: "フォルダ名3")

        let result = FolderDao.findByID(id: 2)
        XCTAssertEqual(result?.name, "フォルダ名2")
    }
}

// MARK: - Helper
private extension FolderDaoTests {

    func verifyFolder(id: Int, name: String, task: Task? = nil) {

        let result = FolderDao.findAll()

        XCTAssertEqual(result.first?.id, id)

        if let resultName = result.first?.name {
            XCTAssertEqual(resultName, name)
        }

        if let resultTask = result.first?.tasks.first {
            XCTAssertEqual(resultTask, task)
        }
    }
    
    func verifyCount(count: Int) {
        let result = FolderDao.findAll()
        XCTAssertEqual(result.count, count)
    }
}
