//
//  TabBarController.swift
//  Diffable
//
//  Created by Vladimir Ho on 20.12.2019.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: EmployeesViewController())
        let vc2 = UINavigationController(rootViewController: EmployeesViewController2())
        viewControllers = [vc1, vc2]
    }

}
