//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public extension Array where Element: AnimationWrapper {

    /// Calls `perform` for each wrapper.
    func perform() {
        forEach { wrapper in
            wrapper.perform()
        }
    }
}
