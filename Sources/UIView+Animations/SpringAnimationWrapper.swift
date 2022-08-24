//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

/// Performs `UIView.animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)`
/// based on the parameters.
open class SpringAnimationWrapper: AnimationWrapper {

    open var parameters: SpringAnimationParameters = .init()

    public override init() {}

    override open func perform() {
        guard parameters.animated else {
            animations()
            completion?(true)
            return
        }
        UIView.animate(with: parameters, animations: {
            self.animations()
        }, completion: { finished in
            self.completion?(finished)
        })
    }
}
