//
//  MocTaskListViewController.swift
//  kushitask
//
//  Created by Kentaro on 2017/06/24.
//  Copyright © 2017年 Kentao Taguchi. All rights reserved.
//

import XCTest
import STV_Extensions
@testable import kushitask

class MocTaskListViewController: XCTestCase {

    var controller: UIViewController!

    func create(identifier: String) -> UIViewController {

        controller = UIStoryboard
            .viewController(storyboardName: TaskListViewController.className,
                            identifier: TaskListViewController.className)
            as! TaskListViewController

        _ = controller.view

        return controller
    }
}
