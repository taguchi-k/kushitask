//
//  TaskListProvider.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation
import STV_Extensions

protocol TaskListProviderDelegate: class {

    /// タスクを削除する
    func deleteTask()
}

final class TaskListProvider: NSObject {

    var tasks = [Task]()
    weak var delegate: TaskListProviderDelegate?

    /// タスクの一覧を設定する
    ///
    /// - Parameter tasks: タスク一覧
    func set(tasks: [Task]) {
        self.tasks = tasks
    }

    func task(index: Int) -> Task {
        guard index < tasks.count else {
            fatalError("tasksの要素数を超えました。")
        }
        return tasks[index]
    }
}

// MARK: - UITableViewDataSource
extension TaskListProvider: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let id = TaskListTableViewCell.className
        let cell = tableView.dequeueReusableCell(withIdentifier: id,
                                                 for: indexPath) as! TaskListTableViewCell
        cell.task = tasks[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            // DBから削除
            TaskDao.delete(id: tasks[indexPath.row].id)
            // 配列から削除
            tasks.remove(at: indexPath.row)
            // table更新
            tableView.deleteRows(at: [IndexPath(row: indexPath.row,
                                                section: indexPath.section)],
                                 with: .fade)
            delegate?.deleteTask()
        }
    }
}
