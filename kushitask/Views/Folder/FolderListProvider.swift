//
//  FolderListProvider.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation
import STV_Extensions

protocol FolderListProviderDelegate: class {

    /// フォルダを削除する
    func deleteFolder()
}

final class FolderListProvider: NSObject {

    var folders = [Folder]()
    weak var delegate: FolderListProviderDelegate?

    /// フォルダの一覧を設定する
    ///
    /// - Parameter folders: フォルダ一覧
    func set(folders: [Folder]) {
        self.folders = folders
    }

    /// 該当のフォルダを取得する
    ///
    /// - Parameter index: TableViewのindex
    /// - Returns: フォルダモデル
    func folder(index: Int) -> Folder {
        guard index < folders.count else {
            fatalError("foldersの要素数を超えました。")
        }
        return folders[index]
    }
}

// MARK: - UITableViewDataSource
extension FolderListProvider: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let id = FolderListTableViewCell.className
        let cell = tableView.dequeueReusableCell(withIdentifier: id,
                                                 for: indexPath) as! FolderListTableViewCell
        cell.folder = folders[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            // DBから削除
            FolderDao.delete(id: folders[indexPath.row].id)
            // 配列から削除
            folders.remove(at: indexPath.row)
            // table更新
            tableView.deleteRows(at: [IndexPath(row: indexPath.row,
                                                section: indexPath.section)],
                                 with: .fade)
            delegate?.deleteFolder()
        }
    }
}
