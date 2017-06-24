//
//  FolderListTableViewCellTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
@testable import kushitask

class FolderListTableViewCellTests: XCTestCase {

    var tableView: UITableView!
    let dataSouce = FakeDataSource()
    var cell: FolderListTableViewCell!

    override func setUp() {
        super.setUp()

        let controller = MocFolderListViewController()
            .create(identifier: FolderListViewController.className)
            as! FolderListViewController

        tableView = controller.tableView
        tableView.dataSource = dataSouce

        cell = tableView.dequeueReusableCell(
            withIdentifier: FolderListTableViewCell.className,
            for: IndexPath(row: 0, section: 0)) as! FolderListTableViewCell
    }

    override func tearDown() {
        super.tearDown()
    }

    /// ラベルのテキストが正しいか
    func testConfigCell() {

        let folder = Folder()
        folder.name = "フォルダ名"
        folder.tasks.append(Task())

        cell.folder = folder

        XCTAssertEqual(cell.textLabel?.text, "フォルダ名")
        XCTAssertEqual(cell.detailTextLabel?.text, "1")
    }
}

extension FolderListTableViewCellTests {

    final class FakeDataSource: NSObject, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
