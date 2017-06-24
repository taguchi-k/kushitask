//
//  AlertType.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import Foundation
import STV_Extensions

enum AlertType {

    case folder(Folder?)
    case task(Task?)

    /// モデルのID
    var id: Int? {
        switch self {
        case .folder(let folder):
            return folder?.id
        case .task(let task):
            return task?.id
        }
    }

    /// モデルのタイトル
    var title: String {
        switch self {
        case .folder(let folder):
            return folder?.name ?? ""
        case .task(let task):
            return task?.title ?? ""
        }
    }

    /// 新規追加時のメッセージ
    var addAlertMessage: String {
        switch self {
        case .folder:
            return "ALERT_ADD_MSG_FOLDER".localized()
        case .task:
            return "ALERT_ADD_MSG_TASK".localized()
        }
    }

    /// 更新時のメッセージ
    var updateAlertMessage: String {
        switch self {
        case .folder:
            return "ALERT_UPDATE_MESSAGE_FOLDER".localized()
        case .task:
            return "ALERT_UPDATE_MESSAGE_TASK".localized()
        }
    }
}
