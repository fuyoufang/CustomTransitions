//
//  BaseFirstViewController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import Foundation
import UIKit
import SnapKit
import Then

class BaseFirstViewController: UIViewController {
    lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(showSecond(sender:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.90147,
                                       green: 0.900031,
                                       blue: 1,
                                       alpha: 1)
        
           
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(backToMenu))
        
        let label = UILabel().then {
            $0.text = "A"
            $0.font = UIFont.systemFont(ofSize: 160)
            $0.textColor = UIColor(red: 162 / 255.0, green: 162 / 255.0, blue: 183 / 255.0, alpha: 1)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-20)
        }
    }
    
    @objc func backToMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showSecond(sender: Any) {
        
    }
}
