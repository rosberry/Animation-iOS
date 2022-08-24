//
//  AppDelegate.swift
//  Example
//
//  Created by Nick Tyunin on 23.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()

        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        FirstCustomTransition.add(to: navigationController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

