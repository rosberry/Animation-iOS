//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit
import Animation

class SecondViewController: UIViewController {

    private lazy var rotateAnimation: KeyframeAnimation = {
        .init(using: SecondViewController.self, duration: 0.3)
        .animationOptions(.curveEaseOut)
        .next(duration: 0.08, times: 3) { viewController, index in
            viewController.rotateButton.transform = .init(rotationAngle: 2 * .pi / 3 * .init(index + 1))
        }
        .next(duration: 0.03) { viewController in
            viewController.rotateButton.transform = .init(scaleX: 2, y: 2)
        }
        .next(duration: 0.03) { viewController in
            viewController.rotateButton.transform = .identity
        }
        .over(start: 0.025, end: 0.15) { viewController in
            viewController.rotateButton.alpha = 0
        }
        .over(start: 0.175, end: 0.275) { viewController in
            viewController.rotateButton.alpha = 1
        }
        .finally { viewController in
            viewController.dismiss(animated: true)
        }
    }()

    private lazy var rotateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(rotateButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rotateButton.frame = .init(x: (view.bounds.width - 100) / 2,
                                   y: (view.bounds.height - 100) / 2,
                                   width: 100,
                                   height: 30)
    }

    // MARK: - Actions

    @objc private func rotateButtonPressed() {
        rotateAnimation(capturing: self, duration: 2)
    }

    // MARK: - Private

    private func setup() {
        view.backgroundColor = .gray
        navigationItem.title = "Second"
        view.addSubview(rotateButton)
    }
}
