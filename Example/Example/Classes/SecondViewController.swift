//
//  ViewController.swift
//  Example
//
//  Created by Nick Tyunin on 23.08.2022.
//

import UIKit

class SecondViewController: UIViewController {
    // MARK: - Subviews


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Actions

    // MARK: - Private

    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "Second"
    }
}
