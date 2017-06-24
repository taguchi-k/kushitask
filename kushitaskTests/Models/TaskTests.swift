//
//  TaskTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
@testable import kushitask

class TaskTests: XCTestCase {

    let task = Task()

    override func setUp() {
        super.setUp()
        TaskDao.deleteAll()
    }

    override func tearDown() {
        TaskDao.deleteAll()
        super.tearDown()
    }

    func testTaskDefault() {
        XCTAssertEqual(task.id, 0)
        XCTAssertEqual(task.title, "")
        XCTAssertNotNil(task.date)
    }

    /// タスクが設定できるか
    func testSetTask() {

        task.id = 1
        task.title = "タイトル"
        task.date = string2Date("2017/01/01")

        verifyTask(id: 1, title: "タイトル", date: "2017/01/01")
    }
}

// MARK: - Helper
private extension TaskTests {

    func verifyTask(id: Int, title: String, date: String) {

        XCTAssertEqual(task.id, id)
        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.date, string2Date(date))
    }

    func string2Date(_ dateString: String) -> Date{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: dateString)!
    }
}
