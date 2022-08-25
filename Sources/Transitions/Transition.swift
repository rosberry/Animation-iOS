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
    static var delay: TimeInterval { get }
    static var options: UIView.AnimationOptions { get }

    /// Use async start if you need afterScreenUpdates snapshots
    static var useAsyncStart: Bool { get }

    init(fromVC: From, toVC: To, containerView: UIView)

    func prepare()
    func animate()
    func complete()
    func start()
}

open class BaseTransition<From: UIViewController, To: UIViewController>: Transition {

    open class var duration: TimeInterval {
        0.3
    }

    open class var delay: TimeInterval {
        0.0
    }

    open class var options: UIView.AnimationOptions {
        []
    }

    open class var useAsyncStart: Bool {
        false
    }

    public let containerView: UIView
    public let fromVC: From
    public let toVC: To

    required public init(fromVC: From, toVC: To, containerView: UIView) {
        self.containerView = containerView
        self.fromVC = fromVC
        self.toVC = toVC
    }

    public func makeSnapshot(from view: UIView, afterScreenUpdates: Bool = false) -> UIView {
        guard let snapshot = view.snapshotView(afterScreenUpdates: afterScreenUpdates) else {
            return .init()
        }
        snapshot.frame = view.convert(view.bounds, to: nil)
        return snapshot
    }

    public func add(snapshot: UIView) {
        containerView.addSubview(snapshot)
    }

    public static func add(to provider: TransitionProvider) {
        BaseTransitioning<Self>().add(to: provider)
    }

    public static func add(to navigationController: UINavigationController) {
        BaseTransitioning<Self>().add(to: navigationController.transitionProvider)
    }

    open func prepare() {

    }

    open func start() {

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
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        let container = transitionContext.containerView
        let transition = CustomTransition(fromVC: fromViewController, toVC: toViewController, containerView: container)
        container.addSubview(toView)
        fromViewController.view.setNeedsLayout()
        fromViewController.view.layoutIfNeeded()
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        transition.prepare()

        func start () {
            transition.start()
            UIView.animate(withDuration: CustomTransition.duration,
                           delay: CustomTransition.delay,
                           options: CustomTransition.options,
                           animations: {
                transition.animate()
            }, completion: { isFinished in
                transition.complete()
                transitionContext.completeTransition(isFinished)
            })
        }

        if CustomTransition.useAsyncStart {
            DispatchQueue.main.async(execute: start)
        }
        else {
            start()
        }
    }
}
