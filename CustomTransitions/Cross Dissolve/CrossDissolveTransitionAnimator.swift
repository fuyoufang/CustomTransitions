//
//  CrossDissolveTransitionAnimator.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class CrossDissolveTransitionAnimator: NSObject {
   
}

extension CrossDissolveTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let completeTransition = {
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
                  completeTransition()
                  return
              }
        
        let fromView = transitionContext.view(forKey: .from)?
            .then {
                $0.frame = transitionContext.initialFrame(for: fromViewController)
                $0.alpha = 1
            }
        
        /*
         在 dismiss 的过程中，toView 可能为空。
         此时 transitionContext 并没有负责管理 toView,
         由 UIKit 负责管理 toView
         */
        let toView = transitionContext.view(forKey: .to)?.then {
            $0.frame = transitionContext.finalFrame(for: toViewController)
            $0.alpha = 0
        }
        
        let containerView = transitionContext.containerView
        if let toView = toView {
            containerView.addSubview(toView)
        }
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            fromView?.alpha = 0
            toView?.alpha = 1
        } completion: { finished in
            completeTransition()
        }

    }
}
