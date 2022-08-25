//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Animation
import UIKit

final class ToSecondTransition: BaseTransition<ViewController, SecondViewController> {

    private lazy var buttonSnapshot = makeSnapshot(from: fromVC.secondViewControllerButton)

    override class var duration: TimeInterval {
        1
    }

    override func prepare() {
        add(snapshot: buttonSnapshot)
    }

    override func start() {
        fromVC.secondViewControllerButton.alpha = 0
        toVC.view.alpha = 0
    }

    override func animate() {
        buttonSnapshot.frame.origin.y = 0
        toVC.view.alpha = 1
    }

    override func complete() {
        buttonSnapshot.removeFromSuperview()
        fromVC.secondViewControllerButton.alpha = 1
    }
}

final class FromSecondTransition: BaseTransition<SecondViewController, ViewController> {

    private lazy var buttonSnapshot = makeSnapshot(from: toVC.secondViewControllerButton, afterScreenUpdates: true)
    var initialButtonFrame: CGRect = .zero

    override class var duration: TimeInterval {
        1
    }

    override class var useAsyncStart: Bool {
        true
    }

    override func prepare() {
        initialButtonFrame = buttonSnapshot.frame
        add(snapshot: buttonSnapshot)
        buttonSnapshot.frame.origin.y = 0
    }

    override func start() {
        toVC.view.alpha = 0
        toVC.secondViewControllerButton.alpha = 0
    }

    override func animate() {
        toVC.view.alpha = 1
        buttonSnapshot.frame = initialButtonFrame
    }

    override func complete() {
        buttonSnapshot.removeFromSuperview()
        toVC.secondViewControllerButton.alpha = 1
    }
}
