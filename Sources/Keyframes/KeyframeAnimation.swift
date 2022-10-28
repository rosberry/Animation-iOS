//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

public class KeyframeAnimation<Capturing: AnyObject> {

    private final class Keyframe {
        let start: TimeInterval
        let duration: TimeInterval
        let animation: (Capturing) -> Void

        var end: TimeInterval {
            start + duration
        }

        init(start: TimeInterval, duration: TimeInterval, animation: @escaping (Capturing) -> Void) {
            self.start = start
            self.duration = duration
            self.animation = animation
        }
    }

    let duration: TimeInterval
    let delay: TimeInterval
    public var options: UIView.KeyframeAnimationOptions
    private var keyframes: [Keyframe] = []
    private var completion: ((Capturing) -> Void)?

    public init(using type: Capturing.Type,
                duration: TimeInterval = 0.3,
                delay: TimeInterval = 0,
                options: UIView.KeyframeAnimationOptions = [],
                animationOptions: UIView.AnimationOptions = []) {
        self.duration = duration
        self.delay = delay
        self.options = options
        self.options.update(with: .init(rawValue: animationOptions.rawValue))
    }

    @discardableResult
    public func options(_ options: UIView.KeyframeAnimationOptions) -> KeyframeAnimation {
        self.options.update(with: options)
        return self
    }

    @discardableResult
    public func animationOptions(_ options: UIView.AnimationOptions) -> KeyframeAnimation {
        self.options.update(with: .init(rawValue: options.rawValue))
        return self
    }

    @discardableResult
    public func next(duration: TimeInterval,
                     animation: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        return next(relativeDuration: duration / self.duration, animation: animation)
    }

    @discardableResult
    public func next(relativeDuration: TimeInterval,
                     animation: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        let nextStart = keyframes.reduce(0.0) { result, keyframe in
            max(result, keyframe.end)
        }
        keyframes.append(.init(start: nextStart,
                               duration: relativeDuration,
                               animation: animation))
        return self
    }

    @discardableResult
    public func next(duration: TimeInterval,
                     times: Int,
                     animation: @escaping (Capturing, Int) -> Void) -> KeyframeAnimation {
        return next(relativeDuration: duration / self.duration, times: times, animation: animation)
    }

    @discardableResult
    public func next(relativeDuration: TimeInterval,
                     times: Int,
                     animation: @escaping (Capturing, Int) -> Void) -> KeyframeAnimation {
        (0..<times).forEach { index in
            next(relativeDuration: relativeDuration) { capturing in
                animation(capturing, index)
            }
        }
        return self
    }

    @discardableResult
    public func over(start: TimeInterval,
                     end: TimeInterval,
                     animation: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        return over(relativeStart: start / self.duration,
                    relativeEnd: end / self.duration,
                    animation: animation)
    }

    @discardableResult
    public func over(start: TimeInterval,
                     duration: TimeInterval,
                     animation: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        return over(relativeStart: start / self.duration,
                    relativeDuration: duration / self.duration,
                    animation: animation)
    }

    @discardableResult
    public func over(relativeStart: TimeInterval,
                     relativeEnd: TimeInterval,
                     animation: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        return over(relativeStart: relativeStart,
                    relativeDuration: relativeEnd - relativeStart,
                    animation: animation)
    }

    @discardableResult
    public func over(relativeStart: TimeInterval,
                     relativeDuration: TimeInterval,
                     animation: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        keyframes.append(.init(start: relativeStart,
                               duration: relativeDuration,
                               animation: animation))
        return self
    }

    @discardableResult
    public func finally(completion: @escaping (Capturing) -> Void) -> KeyframeAnimation {
        self.completion = completion
        return self
    }

    public func callAsFunction(capturing: Capturing,
                               duration: TimeInterval? = nil,
                               delay: TimeInterval? = nil,
                               options: UIView.KeyframeAnimationOptions? = nil,
                               animationOptions: UIView.AnimationOptions? = nil) {

        let duration = duration ?? self.duration
        let delay = delay ?? self.delay
        var allOptions = self.options
        if let options = options {
            allOptions.update(with: options)
        }
        if let animationOptions = animationOptions {
            allOptions.update(with: .init(rawValue: animationOptions.rawValue) )
        }

        UIView.animateKeyframes(withDuration: duration, delay: delay, options: allOptions, animations: {
            self.keyframes.forEach { keyframe in
                UIView.addKeyframe(withRelativeStartTime: keyframe.start,
                                   relativeDuration: keyframe.end) {
                    keyframe.animation(capturing)
                }
            }
        }, completion: { _ in
            self.completion?(capturing)
        })
    }
}
