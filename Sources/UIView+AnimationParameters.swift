//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public extension UIView {

    class func animate(with parameters: BaseAnimationParameters, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animate(withDuration: parameters.duration,
                delay: parameters.delay,
                options: parameters.options,
                animations: animations,
                completion: completion)
    }

    class func animate(with parameters: SpringAnimationParameters, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animate(withDuration: parameters.duration,
                delay: parameters.delay,
                usingSpringWithDamping: parameters.dampingRatio,
                initialSpringVelocity: parameters.velocity,
                options: parameters.options,
                animations: animations,
                completion: completion)
    }
}
