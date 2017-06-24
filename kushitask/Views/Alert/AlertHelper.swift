//
//  AlertHelper.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import UIKit

protocol AlertHelperDelegate: class {
    /// 新規追加
    func addModel(text: String)
    /// 更新
    func updateModel(from id: Int, text: String)
    /// すべて削除
    func deleteAll()
}

final class AlertHelper: NSObject {

    weak var delegate: AlertHelperDelegate?
    private var alert: UIAlertController?
    private var textField: UITextField?
    private var text = ""

    /// モデル新規追加用のアラート作成
    ///
    /// - Parameters:
    ///   - modelType: モデルの種類
    ///   - delegate: 完了通知用のdelegate
    /// - Returns: UIAlertViewControllerのインスタンス
    func add(type: AlertType, delegate: AlertHelperDelegate) -> UIAlertController? {

        self.delegate = delegate

        alert = UIAlertController(title: nil,
                                  message: type.addAlertMessage,
                                  preferredStyle: .alert)
        let cansel = UIAlertAction(title: "ALERT_CANCEL".localized(),
                                   style: .cancel,
                                   handler: nil)
        let save = UIAlertAction(title: "ALERT_SAVE".localized(),
                                 style: .default) { _ in
                                    self.delegate?.addModel(text: self.text)
        }

        save.isEnabled = false

        alert?.addAction(cansel)
        alert?.addAction(save)

        alert?.addTextField { [weak self] (textField: UITextField!) in
            textField.placeholder = type.addAlertMessage
            self?.textField = textField
            self?.addObserver()
        }

        return alert
    }

    /// モデル更新用のアラート作成
    ///
    /// - Parameters:
    ///   - modelType: モデルの種類
    ///   - delegate: 完了通知用のdelegate
    /// - Returns: UIAlertViewControllerのインスタンス
    func update(type: AlertType, delegate: AlertHelperDelegate) -> UIAlertController? {

        self.delegate = delegate

        alert = UIAlertController(title: type.title,
                                  message: type.updateAlertMessage,
                                  preferredStyle: .alert)
        let cansel = UIAlertAction(title: "ALERT_CANCEL".localized(),
                                   style: .cancel,
                                   handler: nil)
        let save = UIAlertAction(title: "ALERT_SAVE".localized(),
                                 style: .default) { _ in
                                    guard let id = type.id else { return }
                                    self.delegate?.updateModel(from: id, text: self.text)
        }

        save.isEnabled = false

        alert?.addAction(cansel)
        alert?.addAction(save)

        alert?.addTextField { [weak self] (textField: UITextField!) in
            textField.placeholder = type.updateAlertMessage
            textField.text = type.title
            self?.textField = textField
            self?.addObserver()
        }

        return alert
    }

    /// モデル削除用のアクションシート作成
    ///
    /// - Parameter delegate: 完了通知用のdelegate
    /// - Returns: UIAlertViewControllerのインスタンス
    func deleteModel(delegate: AlertHelperDelegate) -> UIAlertController? {

        self.delegate = delegate

        alert = UIAlertController(title: nil,
                                  message: nil,
                                  preferredStyle: .actionSheet)
        let cansel = UIAlertAction(title: "ALERT_CANCEL".localized(),
                                   style: .cancel,
                                   handler: nil)
        let delete = UIAlertAction(title: "ALERT_DELETE".localized(),
                                   style: .destructive) {_ in
                                    self.delegate?.deleteAll()
        }
        alert?.addAction(cansel)
        alert?.addAction(delete)

        return alert
    }

    // MARK: - UITextField

    func addObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(textDidChange(notification:)),
                       name: .UITextFieldTextDidChange,
                       object: textField)
    }

    func textDidChange(notification: NSNotification) {
        
        text = textField?.text ?? ""
        
        let saveButton = alert?.actions.last
        saveButton?.isEnabled = text.characters.count > 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
