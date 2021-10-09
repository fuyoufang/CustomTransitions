//
//  SwipeTransitionAnimator.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class SwipeTransitionAnimator: NSObject {
    
    let targetEdge: UIRectEdge
    
    init(targetEdge: UIRectEdge) {
        self.targetEdge = targetEdge
        super.init()
    }
}

extension SwipeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
                  let wasCancelled = transitionContext.transitionWasCancelled
                  transitionContext.completeTransition(!wasCancelled)
                  return
              }
        #warning(" presentationController 的用法")
        let isPresenting = toViewController.presentingViewController == fromViewController
        
        let fromViewInitialFrame = transitionContext.initialFrame(for: fromViewController)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        /*
         debugPrint("fromViewInitialFrame:\(fromViewInitialFrame), fromViewFinalFrame:\(fromViewFinalFrame), toViewFinalFrame:\(toViewFinalFrame), toViewInitialFrame:\(toViewInitialFrame)")
         
         在 iPhone 13 Pro Max 下，isPresent == true 时
         fromViewInitialFrame:(0.0, 0.0, 428.0, 926.0),
         fromViewFinalFrame:(0.0, 0.0, 428.0, 869.0),
         toViewFinalFrame:(0.0, 0.0, 428.0, 926.0),
         toViewInitialFrame:(0.0, 0.0, 0.0, 0.0)
         
         isPresent == false 时
         fromViewInitialFrame:(0.0, 0.0, 428.0, 926.0),
         fromViewFinalFrame:(0.0, 0.0, 428.0, 926.0),
         toViewFinalFrame:(0.0, 0.0, 428.0, 926.0),
         toViewInitialFrame:(0.0, 0.0, 0.0, 0.0)
         
         默认情况下：
         fromView 的起始和终止的 frame 都为 containerView 的 bounds
         toView 的起始的 frame 为 containerView 的 bounds，终止的 frame 为 .zero
         */
        
        let offset: CGVector
        
        switch targetEdge {
        case .left:
            offset = CGVector(dx: 1, dy: 0)
        case .right:
            offset = CGVector(dx: -1, dy: 0)
        case .top:
            offset = CGVector(dx: 0, dy: -1)
        case .bottom:
            offset = CGVector(dx: 0, dy: 1)
        default:
            fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        
        let fromView = transitionContext.view(forKey: .from)
        
        fromView?.frame = fromViewInitialFrame
        if isPresenting {
            // For a presentation, the toView starts off-screen and slides in.
            toView?.frame = toViewFinalFrame.offsetBy(dx: offset.dx * containerView.bounds.size.width * -1,
                                                 dy: offset.dy * containerView.bounds.size.height * -1)
        } else {
            toView?.frame = toViewFinalFrame
        }
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation.
        if isPresenting {
            if let toView = toView {
                containerView.addSubview(toView)
            }
        } else {
            // -addSubview places its argument at the front of the subview stack.
            // For a dismissal animation we want the fromView to slide away,
            // revealing the toView.  Thus we must place toView under the fromView.
            if let toView = toView, let fromView = fromView {
                containerView.insertSubview(toView, belowSubview: fromView)
            }
        }
        
        let transitionDuration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration) {
            if isPresenting {
                toView?.frame = toViewFinalFrame
            } else {
                // For a dismissal, the fromView slides off the screen.
                fromView?.frame = fromViewInitialFrame.offsetBy(dx: offset.dx * containerView.bounds.size.width,
                                                                dy: offset.dy * containerView.bounds.size.height)
            }
        } completion: { finished in
            let wasCancelled = transitionContext.transitionWasCancelled
            
            // Due to a bug with unwind segues targeting a view controller inside
            // of a navigation controller, we must remove the toView in cases where
            // an interactive dismissal was cancelled.  This bug manifests as a
            // soft UI lockup after canceling the first interactive modal
            // dismissal; further invocations of the unwind segue have no effect.
            //
            // The navigation controller's implementation of
            // -segueForUnwindingToViewController:fromViewController:identifier:
            // returns a segue which only dismisses the currently presented
            // view controller if it determines that the navigation controller's
            // view is not in the view hierarchy at the time the segue is invoked.
            // The system does not remove toView when we invoke -completeTransition:
            // with a value of NO if this is a dismissal transition.
            //
            // Note that it is not necessary to check for further conditions
            // specific to this bug (e.g. isPresenting==NO &&
            // [toViewController isKindOfClass:UINavigationController.class])
            // because removing toView is a harmless operation in all scenarios
            // except for a successfully completed presentation transition, where
            // it would result in a blank screen.
            if wasCancelled {
                toView?.removeFromSuperview()
            }
            
            // When we complete, tell the transition context
            // passing along the BOOL that indicates whether the transition
            // finished or not.
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
