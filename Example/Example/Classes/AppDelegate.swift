//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()

        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        ToSecondTransition.add(to: navigationController)
        FromSecondTransition.add(to: navigationController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

