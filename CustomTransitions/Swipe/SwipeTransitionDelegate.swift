//
//  SwipeTransitionDelegate.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class SwipeTransitionDelegate: NSObject {
    var targetEdge: UIRectEdge = .right
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    
}

extension SwipeTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    
    //  The system calls this method on the presented view controller's
    //  transitioningDelegate to retrieve the animator object used for animating
    //  the presentation of the incoming view controller.  Your implementation is
    //  expected to return an object that conforms to the
    //  UIViewControllerAnimatedTransitioning protocol, or nil if the default
    //  presentation animation should be used.
    //
    
    /// 系统会在即将呈现的 view controller 的 transitioningDelegate 对象上调用此方法，来获取一个动画对象。
    /// 这个动画对象，负责即将呈现的 view controller 的转场动画。
    /// 返回值需要是一个实现了 UIViewControllerAnimatedTransitioning 协议的对象，或者返回 nil，表示使用默认的转成动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(targetEdge: self.targetEdge)
    }

    //  The system calls this method on the presented view controller's
    //  transitioningDelegate to retrieve the animator object used for animating
    //  the dismissal of the presented view controller.  Your implementation is
    //  expected to return an object that conforms to the
    //  UIViewControllerAnimatedTransitioning protocol, or nil if the default
    //  dismissal animation should be used.
    //
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(targetEdge: self.targetEdge)
    }

    //  If a <UIViewControllerAnimatedTransitioning> was returned from
    //  -animationControllerForPresentedController:presentingController:sourceController:,
    //  the system calls this method to retrieve the interaction controller for the
    //  presentation transition.  Your implementation is expected to return an
    //  object that conforms to the UIViewControllerInteractiveTransitioning
    //  protocol, or nil if the transition should not be interactive.
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // You must not return an interaction controller from this method unless
        // the transition will be interactive.
        guard let gestureRecognizer = gestureRecognizer else {
            return nil
        }
        return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
    }

    //  If a <UIViewControllerAnimatedTransitioning> was returned from
    //  -animationControllerForDismissedController:,
    //  the system calls this method to retrieve the interaction controller for the
    //  dismissal transition.  Your implementation is expected to return an
    //  object that conforms to the UIViewControllerInteractiveTransitioning
    //  protocol, or nil if the transition should not be interactive.
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // You must not return an interaction controller from this method unless
        // the transition will be interactive.
        guard let gestureRecognizer = gestureRecognizer else {
            return nil
        }
        return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
    }
    
    
}
