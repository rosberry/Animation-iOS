//
//  FirstCustomTransition.swift
//  Example
//
//  Created by Nick Tyunin on 23.08.2022.
//

import Animation
import Foundation

final class FirstCustomTransition: BaseTransition<ViewController, SecondViewController> {

    private lazy var buttonSnapshot = makeSnapshot(from: fromVC.secondViewControllerButton)

    override class var duration: TimeInterval {
        1
    }

    override func prepare() {
        containerView.backgroundColor = .white
        fromVC.view.setNeedsLayout()
        fromVC.view.layoutIfNeeded()
        add(snapshot: buttonSnapshot)
    }

    override func animate() {
        buttonSnapshot.frame.origin.y = 0
    }

    override func complete() {
        buttonSnapshot.removeFromSuperview()
    }
}
