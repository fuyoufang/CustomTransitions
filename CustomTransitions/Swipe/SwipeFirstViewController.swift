//
//  SwipeFirstViewController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class SwipeFirstViewController: BaseFirstViewController {
    
    /// 懒加载自定义的转场代理
    lazy var transitionDelegate = SwipeTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swipe"
        nextButton.setTitle("Present With Custom Transition", for: .normal)
        
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
            showSecond(sender: gestureRecognizer)
        default:
            break
        }
        // 其他的 case SwipeTransitionInteractionController 中进行了处理
    }
    
    @objc override func showSecond(sender: Any) {
        // 此处与 Cross Dissolve 的 demo 不同，
        // 这里使用一个单独的对象作为过渡委托，而不是（当前的）self。
        // 由 SwipeTransitionDelegate 来提供转场动画的控制器和交互控制器，
        // 这样使得代码更加清晰
        let transitionDelegate = self.transitionDelegate
        
        
        if let gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer {
            // 如果是交互转场，则需要将手势识别器传递给 SwipeTransitionDelegate 对象
            // 这样它才能正确针对转场动画提供必要的 <UIViewControllerInteractiveTransitioning>
            
            transitionDelegate.gestureRecognizer = gestureRecognizer
            
            // 设置`即将显示`的视图控制器的屏幕边缘。
            // 这将匹配我们之前配置 UIScreenEdgePanGestureRecognizer 的边缘。
            
            // 注意：在 iOS 8.3 之前，我们无法获取手势识别器边缘配置的值
            // 因为查询其边缘属性时， UIScreenEdgePanGestureRecognizer 总是会返回 .none
            if #available(iOS 8.3, *) {
                transitionDelegate.targetEdge = gestureRecognizer.edges
            } else {
                transitionDelegate.targetEdge = .left
            }
        } else {
            transitionDelegate.gestureRecognizer = nil
        }
        let secondViewController = SwipeSecondViewController().then {
            // 请注意，view controller 没有对其 transitioningDelegate 的强引用（使用 weak 进行修饰）。
            // 如果将一个单独的对象实例化为 transitioningDelegate，一定要确保持有了该对象的强引用。
            $0.transitioningDelegate = transitionDelegate
            
            // 将 modalPresentationStyle 设置为 .fullScreen
            // 使 <ContextTransitioning> 能够更准确的提供参与转场的 view controller 的初始和最终 frame。
            $0.modalPresentationStyle = .fullScreen
        }
        
        present(secondViewController, animated: true, completion: nil)
    }
}
