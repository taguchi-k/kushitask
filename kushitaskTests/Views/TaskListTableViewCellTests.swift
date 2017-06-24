//
//  TaskListTableViewCellTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
import STV_Extensions
@testable import kushitask

class TaskListTableViewCellTests: XCTestCase {

    var tableView: UITableView!
    let dataSouce = FakeDataSource()
    var cell: TaskListTableViewCell!

    override func setUp() {
        super.setUp()

        let controller = MocTaskListViewController()
            .create(identifier: TaskListViewController.className)
            as! TaskListViewController

        tableView = controller.tableView
        tableView.dataSource = dataSouce

        cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListTableViewCell.className,
            for: IndexPath(row: 0, section: 0)) as! TaskListTableViewCell
    }

    override func tearDown() {
        super.tearDown()
    }

    /// ラベルのテキストが正しいか
    func testConfigCell() {

        let task = Task()
        task.title = "タイトル"
        task.date = "2017/01/01".toDate(dateFormat: "yyyy/MM/dd")

        cell.task = task

        XCTAssertEqual(cell.textLabel?.text, "タイトル")
        XCTAssertEqual(cell.detailTextLabel?.text, "2017/01/01")
    }
}

extension TaskListTableViewCellTests {

    final class FakeDataSource: NSObject, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
