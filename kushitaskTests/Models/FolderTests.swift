//
//  FolderTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
import RealmSwift
@testable import kushitask

class FolderTests: XCTestCase {

    let folder = Folder()

    override func setUp() {
        super.setUp()
        FolderDao.deleteAll()
    }

    override func tearDown() {
        FolderDao.deleteAll()
        super.tearDown()
    }

    func testFolderDefault() {
        XCTAssertEqual(folder.id, 0)
        XCTAssertEqual(folder.name, "")
        XCTAssertNotNil(folder.date)
        XCTAssertNotNil(folder.tasks)
    }

    /// フォルダが設定できるか
    func testSetFolder() {

        folder.id = 1
        folder.name = "フォルダ名"
        folder.date = string2Date("2017/01/01")

        let task = Task()
        folder.tasks.append(task)

        verifyFolder(id: 1, name: "フォルダ名", date: "2017/01/01", task: task)
    }
}

// MARK: - Helper
private extension FolderTests {

    func verifyFolder(id: Int, name: String, date: String, task: Task) {

        XCTAssertEqual(folder.id, id)
        XCTAssertEqual(folder.name, name)
        XCTAssertEqual(folder.date, string2Date(date))
        XCTAssertEqual(folder.tasks.first, task)
    }

    func string2Date(_ dateString: String) -> Date{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: dateString)!
    }
}
