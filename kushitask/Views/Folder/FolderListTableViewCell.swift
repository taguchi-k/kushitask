//
//  FolderListTableViewCell.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import UIKit

final class FolderListTableViewCell: UITableViewCell {

    var folder: Folder? {
        didSet {
            guard let folder = folder else { return }

            textLabel?.text = folder.name
            detailTextLabel?.text = String(folder.tasks.count)
        }
    }
}
