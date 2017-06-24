//
//  TaskDaoTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
@testable import kushitask

class TaskDaoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        TaskDao.deleteAll()
    }

    override func tearDown() {
        TaskDao.deleteAll()
        super.tearDown()
    }

    /// 登録できるか
    func testAddTask() {
        _ = TaskDao.add(title: "タイトル")
        verifyTask(id: 1, title: "タイトル")
    }

    /// 変更できるか
    func testUpdateTask() {

        _ = TaskDao.add(title: "タイトル")

        let result = TaskDao.findAll().first
        result?.title = "タイトル更新"
        TaskDao.update(model: result!)

        verifyTask(id: 1, title: "タイトル更新")
    }

    /// 削除できるか
    func testDeleteTask() {
        _ = TaskDao.add(title: "タイトル")
        TaskDao.delete(id: 1)
        verifyCount(count: 0)
    }

    /// タスクが取得できるか
    func testFindAllTask() {

        _ = TaskDao.add(title: "タイトル1")
        _ = TaskDao.add(title: "タイトル2")
        _ = TaskDao.add(title: "タイトル3")

        verifyCount(count: 3)
    }

    /// タスクが更新日の降順で取得されるか
    func testFindAllTask_ForOrder() {

        _ = TaskDao.add(title: "タイトル1")
        sleep(1)
        _ = TaskDao.add(title: "タイトル2")
        sleep(1)
        _ = TaskDao.add(title: "タイトル3")

        let result = TaskDao.findAll()

        XCTAssertEqual("タイトル3", result[0].title)
        XCTAssertEqual("タイトル2", result[1].title)
        XCTAssertEqual("タイトル1", result[2].title)
    }

    /// 該当のタスクが取得できるか
    func testFindByIDTask() {

        _ = TaskDao.add(title: "タイトル1")
        _ = TaskDao.add(title: "タイトル2")
        _ = TaskDao.add(title: "タイトル3")

        let result = TaskDao.findByID(id: 2)
        XCTAssertEqual("タイトル2", result?.title)
    }
}

// MARK: - Helper
private extension TaskDaoTests {

    func verifyTask(id: Int, title: String) {

        let result = TaskDao.findAll()

        XCTAssertEqual(result.first?.id, id)

        if let resultTitle = result.first?.title {
            XCTAssertEqual(resultTitle, title)
        }
    }
    
    func verifyCount(count: Int) {
        let result = TaskDao.findAll()
        XCTAssertEqual(result.count, count)
    }
}
