//
//  FolderListViewController.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import UIKit
import STV_Extensions

final class FolderListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    fileprivate let dataSource = FolderListProvider()
    fileprivate var alert: UIAlertController?

    // MARK - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFolderList()
    }

    // MARK: - Edit
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        setupEditButton(isEditing: editing)
    }
}

// MARK: - UITableViewDelegate
extension FolderListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let folder = dataSource.folder(index: indexPath.row)

        if isEditing {
            // フォルダ名編集
            showUpdateAlert(folder: folder)
        } else {
            // タスク一覧画面に遷移
            let vc = TaskListViewController.create(folder: folder)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - FolderListProviderDelegate
extension FolderListViewController: FolderListProviderDelegate {

    func deleteFolder() {
        reloadFolderList()
    }
}

// MARK: - AlertHelperDelegate
extension FolderListViewController: AlertHelperDelegate {

    func addModel(text: String) {
        FolderDao.add(name: text)
        reloadFolderList()
    }

    func updateModel(from id: Int, text: String) {

        if let folder = FolderDao.findByID(id: id) {
            let lastFolder = Folder(value: folder)
            lastFolder.name = text
            FolderDao.update(model: lastFolder)
        }
        reloadFolderList()
    }

    func deleteAll() {
        FolderDao.deleteAll()
        reloadFolderList()
    }
}

// MARK: - private
private extension FolderListViewController {

    /// 初期化
    func setup() {
        setupNavigationBar()
        setupTableView()
    }

    /// ナビゲーションバーを設定する
    func setupNavigationBar() {
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
            "DELETE_ALL".localized() : "FOLDER_ADD".localized()
    }

    /// フォルダ一覧を取得する
    func reloadFolderList() {

        let folders = FolderDao.findAll()
        dataSource.set(folders: folders)
        tableView.reloadData()
    }

    // MARK - Alert
    func showAddAlert() {
        if let alert = AlertHelper().add(type: .folder(nil), delegate: self) {
            self.alert = alert
            present(alert, animated: true) { self.alert = nil }
        }
    }

    func showUpdateAlert(folder: Folder) {
        if let alert = AlertHelper().update(type: .folder(folder), delegate: self) {
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
