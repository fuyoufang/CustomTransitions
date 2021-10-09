//
//  SwipeTransitionInteractionController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

/// Abstract:
/// The interaction controller for the Swipe demo.  Tracks a UIScreenEdgePanGestureRecognizer
/// from a specified screen edge and derives the completion percentage for the
/// transition.
class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    let gestureRecognizer: UIScreenEdgePanGestureRecognizer
    let edge: UIRectEdge
    var transitionContext: UIViewControllerContextTransitioning?
    
    init(gestureRecognizer: UIScreenEdgePanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        assert(edge == .top || edge == .bottom ||
               edge == .left || edge == .right,
                 "edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        super.init()
        // Add self as an observer of the gesture recognizer so that this
        // object receives updates as the user moves their finger.
        gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate(gestureRecognizer:)))
    }
    
    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(gestureRecognizeDidUpdate(gestureRecognizer:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Save the transitionContext for later.
        self.transitionContext = transitionContext
        
        super.startInteractiveTransition(transitionContext)
    }
    
    
    //! Returns the offset of the pan gesture recognizer from the edge of the
    //! screen as a percentage of the transition container view's width or height.
    //! This is the percent completed for the interactive transition.
    func percent(forGesture gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        // Because view controllers will be sliding on and off screen as part
        // of the animation, we want to base our calculations in the coordinate
        // space of the view that will not be moving: the containerView of the
        // transition context.
        guard let containerView = transitionContext?.containerView else {
            return 0
        }
        
        let location = gesture.location(in: containerView)
        // Figure out what percentage we've gone.
        let containerViewWidth = containerView.bounds.width
        let containerViewHeight = containerView.bounds.height
        
        // Return an appropriate percentage based on which edge we're dragging
        // from.
        switch edge {
        case .left:
            return location.x / containerViewWidth
        case .right:
            return (containerViewWidth - location.x) / containerViewWidth
        case .top:
            return location.y / containerViewHeight
        case .bottom:
            return (containerViewHeight - location.y) / containerViewHeight
        default:
            fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight")
        }
    }
    
    //! Action method for the gestureRecognizer.
    @objc func gestureRecognizeDidUpdate(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            // The Began state is handled by the view controllers.  In response
            // to the gesture recognizer transitioning to this state, they
            // will trigger the presentation or dismissal.
            break
        case .changed:
            // We have been dragging! Update the transition context accordingly.

            update(percent(forGesture: gestureRecognizer))
        case .ended:
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            if percent(forGesture: gestureRecognizer) > 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            // Something happened. cancel the transition.
            cancel()
        }
        
    }
    
}
