//
//  AppDelegate.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        window.rootViewController = ViewControllersFactory.makeMainViewController()
        window.makeKeyAndVisible()

        return true
    }

}
