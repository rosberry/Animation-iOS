//
//  ViewController.swift
//  Example
//
//  Created by Nick Tyunin on 23.08.2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Subviews

    private(set) lazy var secondViewControllerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Second", for: .normal)
        button.addTarget(self, action: #selector(secondViewControllerButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        secondViewControllerButton.center = view.center
        secondViewControllerButton.bounds = .init(x: 0, y: 0, width: 120, height: 48)
    }

    // MARK: - Actions

    @objc private func secondViewControllerButtonPressed() {
        let viewController = SecondViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Private

    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "Home"
        view.addSubview(secondViewControllerButton)
    }
}

