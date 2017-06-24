//
//  TaskListViewControllerTests.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
import STV_Extensions
@testable import kushitask

class TaskListViewControllerTests: XCTestCase {

    var vc: TaskListViewController!

    override func setUp() {
        super.setUp()

        vc = UIStoryboard
            .viewController(storyboardName: TaskListViewController.className,
                            identifier: TaskListViewController.className)
            as! TaskListViewController

        _ = vc.view
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHasTableView() {
        XCTAssertNotNil(vc.tableView)
    }

    func testTableViewDelegate() {
        XCTAssertTrue(vc.tableView.delegate is TaskListViewController)
    }

    func testTableViewDataSource() {
        XCTAssertTrue(vc.tableView.dataSource is TaskListProvider)
    }

    // MARK: - ToolBarEditButton
    func testToolBarEditButton_When_Default() {
        let title = vc.editButton.title
        XCTAssertEqual(title, "タスク追加")
    }

    func testToolBarEditButton_When_EditModeOff() {
        vc.isEditing = false
        let title = vc.editButton.title
        XCTAssertEqual(title, "タスク追加")
    }

    func testToolBarEditButton_When_EditModeOn() {
        vc.isEditing = true
        let title = vc.editButton.title
        XCTAssertEqual(title, "すべて削除")
    }

    // MARK: - NavigationBarEditButton
    func testNavigationBarEditButtonTitle_When_Default() {
        let title = vc.navigationItem.rightBarButtonItem?.title
        XCTAssertEqual(title, "編集")
    }

    func testNavigationBarEditButtonTitle_When_EditMode_OFF() {
        vc.isEditing = false
        let title = vc.navigationItem.rightBarButtonItem?.title
        XCTAssertEqual(title, "編集")
    }

    func testNavigationBarEditButtonTitle_When_EditMode_ON() {
        vc.isEditing = true
        let title = vc.navigationItem.rightBarButtonItem?.title
        XCTAssertEqual(title, "完了")
    }
}
