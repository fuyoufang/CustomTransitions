//
//  SwipeSecondViewController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class SwipeSecondViewController: BaseSecondViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edges: [UIRectEdge] = [.left, .right]
        
        edges.forEach { item in
            let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                     action: #selector(interactiveTransitionRecognizerAction))
                .then {
                    $0.edges = item
                }
            view.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    
    @objc func interactiveTransitionRecognizerAction(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            
            back(sender: gestureRecognizer)
        default:
            break
        }
        
    }
    
    
    override func back(sender: Any) {
        
        // Check if we were presented with our custom transition delegate.
        // If we were, update the configuration of the
        // AAPLSwipeTransitionDelegate with the gesture recognizer and
        // targetEdge for this view controller.
        
        
        if let transitionDelegate = self.transitioningDelegate as? SwipeTransitionDelegate {
            // If this will be an interactive presentation, pass the gesture
            // recognizer along to our AAPLSwipeTransitionDelegate instance
            // so it can return the necessary
            // <UIViewControllerInteractiveTransitioning> for the presentation.
            if let gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer {
                transitionDelegate.gestureRecognizer = gestureRecognizer
                
                // Set the edge of the screen to dismiss this view controller
                // from.  This will match the edge we configured the
                // UIScreenEdgePanGestureRecognizer with previously.
                //
                // NOTE: We can not retrieve the value of our gesture recognizer's
                //       configured edges because prior to iOS 8.3
                //       UIScreenEdgePanGestureRecognizer would always return
                //       UIRectEdgeNone when querying its edges property.
                transitionDelegate.targetEdge = gestureRecognizer.edges
            } else {
                transitionDelegate.gestureRecognizer = nil
            }
        }
        
        super.back(sender: sender)
    }
}
