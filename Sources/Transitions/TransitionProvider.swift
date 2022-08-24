//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

public final class TransitionProvider: NSObject {

    var transitionsMap: [String: [String: UIViewControllerAnimatedTransitioning]] = [:]

    public init(navigationController: UINavigationController) {
        super.init()
        navigationController.delegate = self
    }

    public func register(from fromVCType: UIViewController.Type,
                         to toVCType: UIViewController.Type,
                         transitioning: UIViewControllerAnimatedTransitioning) {
        let fromKey = String(describing: fromVCType)
        let toKey = String(describing: toVCType)
        var from = transitionsMap[fromKey] ?? [:]
        from[toKey] = transitioning
        transitionsMap[fromKey] = from

    }
}

// MARK: - UINavigationControllerDelegate
extension TransitionProvider: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromKey = String(describing: type(of: fromVC))
        let toKey = String(describing: type(of: toVC))

        return transitionsMap[fromKey]?[toKey]
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension TransitionProvider: UIViewControllerTransitioningDelegate {

}
