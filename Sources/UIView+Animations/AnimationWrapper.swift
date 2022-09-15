//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

/// Base class for animation wrappers.
open class AnimationWrapper {

    /// The animations closure.
    open var animations: () -> Void = {}

    /// The animations completion closure. This closure has no return value and takes a Bool argument
    /// that indicates whether or not the animations actually finished.
    open var completion: ((Bool) -> Void)?

    public init() {}

    /// Performs the animations.
    open func perform() {

    }
}
