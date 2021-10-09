//
//  BaseSecondViewController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit

class BaseSecondViewController: UIViewController {
    
    lazy var dismissButton = UIButton().then {
        $0.setTitle("Dismiss", for: .normal)
        $0.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255 / 255.0,
                                       green: 226 / 255.0,
                                       blue: 226 / 255.0,
                                       alpha: 1)
        
        
        let label = UILabel().then {
            $0.text = "B"
            $0.font = UIFont.systemFont(ofSize: 160)
            $0.textColor = UIColor(red: 183 / 255.0, green: 162 / 255.0, blue: 162 / 255.0, alpha: 1)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-20)
        }
    }
    
    @objc func back(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
