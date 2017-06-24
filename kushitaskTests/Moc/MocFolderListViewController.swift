//
//  MocFolderListViewController.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
import STV_Extensions
@testable import kushitask

final class MocFolderListViewController: NSObject {

    var controller: UIViewController!

    func create(identifier: String) -> UIViewController {

        controller = UIStoryboard
            .viewController(storyboardName: FolderListViewController.className,
                            identifier: FolderListViewController.className)
            as! FolderListViewController

        _ = controller.view

        return controller
    }
}
