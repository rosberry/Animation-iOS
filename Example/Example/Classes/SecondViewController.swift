//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private

    private func setup() {
        view.backgroundColor = .gray
        navigationItem.title = "Second"
    }
}
