//
//  CrossDissolveFirstViewController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class CrossDissolveFirstViewController: BaseFirstViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cross Dissolve"
        nextButton.setTitle("Present With Custom Transition", for: .normal)
    }
    
    @objc override func showSecond(sender: Any) {
        let secondViewController = CrossDissolveSecondViewController().then {
            $0.transitioningDelegate = self
            $0.modalPresentationStyle = .fullScreen
        }
        
        present(secondViewController, animated: true, completion: nil)
    }
    
}

extension CrossDissolveFirstViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }
}
