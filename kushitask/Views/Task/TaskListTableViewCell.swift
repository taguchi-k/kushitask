//
//  TaskListTableViewCell.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import UIKit
import STV_Extensions

final class TaskListTableViewCell: UITableViewCell {

    var task: Task? {
        didSet {
            guard let task = task else { return }

            textLabel?.text = task.title
            detailTextLabel?.text = task.date.toStr(dateFormat: "yyyy/MM/dd")
        }
    }
}
