//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

/// Performs `UIView.animate(withDuration:delay:options:animations:completion:)` based on the parameters.
open class BaseAnimationWrapper: AnimationWrapper {

    open var parameters: BaseAnimationParameters = .init()

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
