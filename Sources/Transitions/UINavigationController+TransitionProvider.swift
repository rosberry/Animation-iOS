//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

extension UINavigationController {

    private static var transitionProviderHandle: String = "TransitionProvider"

    public var transitionProvider: TransitionProvider {
        get {
            guard let storedProvider = objc_getAssociatedObject(self, &UINavigationController.transitionProviderHandle) as? TransitionProvider else {
                let provider = TransitionProvider(navigationController: self)
                self.transitionProvider = provider
                return provider
            }
            return storedProvider
        }
        set {
            objc_setAssociatedObject(self, &UINavigationController.transitionProviderHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
