//
//  AppDelegate.swift
//  Template
//
//  Created by Cezary Wojcik on 11/4/17.
//  Copyright © 2017 Cezary Wojcik. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let app = App()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.app.configure()

        self.window = UIWindow()
        self.window?.backgroundColor = .white
        let rootViewController = UIHostingController(rootView: RootView(app: app))
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        self.app.flow.appLaunch()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.app.flow.appForegrounded()
    }

}
