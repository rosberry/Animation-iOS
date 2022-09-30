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

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromKey = String(describing: type(of: source))
        let toKey = String(describing: type(of: presented))
        return transitionsMap[fromKey]?[toKey]
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presenting = dismissed.presentingViewController else {
            return nil
        }
        let fromKey = String(describing: type(of: dismissed))
        var toKey = String(describing: type(of: presenting))
        var transition = transitionsMap[fromKey]?[toKey]
        if transition == nil,
           let navigationViewController = presenting as? UINavigationController,
           let presenting = navigationViewController.viewControllers.last {
            toKey = String(describing: type(of: presenting))
            transition = transitionsMap[fromKey]?[toKey]
        }
        return transition
    }
}
