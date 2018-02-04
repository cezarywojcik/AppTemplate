//
//  RootViewController.swift
//  Template
//
//  Created by Cezary Wojcik on 11/4/17.
//  Copyright © 2017 Cezary Wojcik. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - properties

    private unowned let app: App

    var currentViewController: UIViewController? {
        didSet {
            let changeViewController: () -> Void = { [weak self] in
                if let oldViewController = oldValue {
                    oldViewController.view.removeFromSuperview()
                    oldViewController.willMove(toParentViewController: nil)
                    oldViewController.removeFromParentViewController()
                }
                guard let currentViewController = self?.currentViewController else {
                    return
                }
                self?.addChildViewController(currentViewController)
                self?.view.addSubview(currentViewController.view)
                currentViewController.didMove(toParentViewController: self)
            }
            if Thread.isMainThread {
                changeViewController()
            } else {
                DispatchQueue.main.async {
                    changeViewController()
                }
            }
        }
    }

    // MARK: - initialization

    init(app: App) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

}
