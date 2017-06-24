//
//  TaskListViewController.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation
import UIKit
import STV_Extensions

final class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    fileprivate let dataSource = TaskListProvider()
    fileprivate var folder = Folder()
    fileprivate var alert: UIAlertController?

    // MARK: - Factory
    static func create(folder: Folder) -> TaskListViewController {

        guard let vc = UIStoryboard.viewController(storyboardName: className,
                                                   identifier: className)
            as? TaskListViewController else {
                fatalError("unwap TaskListViewController")
        }
        vc.folder = folder
        return vc
    }

    // MARK - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTaskList()
    }

    // MARK: - Edit
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        setupEditButton(isEditing: editing)
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let task = dataSource.task(index: indexPath.row)

        // タスク名編集
        if isEditing {
            showUpdateAlert(task: task)
        }
    }
}

// MARK: - TaskListProviderDelegate
extension TaskListViewController: TaskListProviderDelegate {

    func deleteTask() {

        if let lastFolder = FolderDao.findByID(id: folder.id) {
            folder = lastFolder
        }
        reloadTaskList()
    }
}

// MARK: - AlertHelperDelegate
extension TaskListViewController: AlertHelperDelegate {

    func addModel(text: String) {

        let task = TaskDao.add(title: text)

        // タスクをフォルダに紐付ける
        folder.tasks.append(task)
        FolderDao.update(model: folder)

        reloadTaskList()
    }

    func updateModel(from id: Int, text: String) {

        if let task = TaskDao.findByID(id: id) {
            let lastTask = Task(value: task)
            lastTask.title = text
            TaskDao.update(model: lastTask)
        }
        reloadTaskList()
    }

    func deleteAll() {

        // タスク
        folder.tasks.forEach { TaskDao.delete(id: $0.id) }

        // フォルダ
        if let lastFolerModel = FolderDao.findByID(id: folder.id) {
            let lastFolder = Folder(value: lastFolerModel)
            FolderDao.update(model: lastFolder)
            folder = lastFolder
        }
        reloadTaskList()
    }
}

// MARK: - private
private extension TaskListViewController {

    /// 初期化
    func setup() {
        setupNavigationBar()
        setupTableView()
    }

    /// ナビゲーションバーを設定する
    func setupNavigationBar() {
        hideBackButtonText()
        title = folder.name
        navigationItem.rightBarButtonItem = editButtonItem
    }

    /// テーブルビューを設定する
    func setupTableView() {
        dataSource.delegate = self
        tableView.dataSource = dataSource
    }

    /// 編集ボタンのタイトルを設定する
    ///
    /// - Parameter isEditing: 編集モードかどうか
    func setupEditButton(isEditing: Bool) {
        editButton.title = isEditing ?
            "DELETE_ALL".localized() : "TASK_ADD".localized()
    }

    /// タスク一覧を取得する
    func reloadTaskList() {

        let tasks = Array(folder.tasks).sorted { $0.date > $1.date }
        dataSource.set(tasks: tasks)
        tableView.reloadData()
    }

    // MARK - Alert
    func showAddAlert() {
        if let alert = AlertHelper().add(type: .task(nil), delegate: self) {
            self.alert = alert
            present(alert, animated: true) { self.alert = nil }
        }
    }

    func showUpdateAlert(task: Task) {
        if let alert = AlertHelper().update(type: .task(task), delegate: self) {
            self.alert = alert
            present(alert, animated: true) { self.alert = nil }
        }
    }

    func showActionSheet() {
        if let alert = AlertHelper().deleteModel(delegate: self) {
            self.alert = alert
            present(alert, animated: true) { self.alert = nil }
        }
    }

    //MARK : - Action
    @IBAction func didTapEditMemo() {
        if isEditing {
            showActionSheet()
        } else {
            showAddAlert()
        }
    }
}
