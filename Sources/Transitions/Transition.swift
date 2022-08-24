//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit
import Foundation

public protocol Transition {
    associatedtype From: UIViewController
    associatedtype To: UIViewController

    var containerView: UIView { get }
    var fromVC: From { get }
    var toVC: To { get }

    static var duration: TimeInterval { get }

    init(fromVC: From, toVC: To, containerView: UIView)

    func prepare()
    func animate()
    func complete()
}

open class BaseTransition<From: UIViewController, To: UIViewController>: Transition {

    open class var duration: TimeInterval {
        0.3
    }

    public let containerView: UIView
    public let fromVC: From
    public let toVC: To

    private var snapshots: [UIView] = []

    required public init(fromVC: From, toVC: To, containerView: UIView) {
        self.containerView = containerView
        self.fromVC = fromVC
        self.toVC = toVC
    }

    public func makeSnapshot(from view: UIView) -> UIView {
        guard let snapshot = view.snapshotView(afterScreenUpdates: true) else {
            return .init()
        }
        snapshot.frame = view.convert(view.bounds, to: nil)
        return snapshot
    }

    public func add(snapshot: UIView) {
        containerView.addSubview(snapshot)
        snapshots.append(snapshot)
    }

    public static func add(to provider: TransitionProvider) {
        BaseTransitioning<Self>().add(to: provider)
    }

    public static func add(to navigationController: UINavigationController) {
        BaseTransitioning<Self>().add(to: navigationController.transitionProvider)
    }

    open func prepare() {

    }

    open func animate() {

    }

    open func complete() {
        
    }
}

open class BaseTransitioning<CustomTransition: Transition>: NSObject, UIViewControllerAnimatedTransitioning {

    typealias From = CustomTransition.From
    typealias To = CustomTransition.To

    func add(to provider: TransitionProvider) {
        provider.register(from: From.self, to: To.self, transitioning: self)
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        CustomTransition.duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? From,
              let toViewController = transitionContext.viewController(forKey: .to) as? To,
              let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let container = transitionContext.containerView
        let transition = CustomTransition(fromVC: fromViewController, toVC: toViewController, containerView: container)

        container.addSubview(toView)
        transition.prepare()

        DispatchQueue.main.async {
            toView.isHidden = true
            fromView.isHidden = true
        }

        UIView.animate(withDuration: CustomTransition.duration, animations: {
            transition.animate()
        }, completion: { isFinished in
            toView.isHidden = false
            fromView.isHidden = false
            transition.complete()
            transitionContext.completeTransition(isFinished)
        })
    }
}
