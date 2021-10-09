//
//  MenuViewController.swift
//  CustomTransitions
//
//  Created by fuyoufang on 2021/10/9.
//

import UIKit

struct MenuItem {
    let title: String
    let detail: String
    let action: () -> Void
}

struct MenuSection {
    let title: String
    let items: [MenuItem]
}

class MenuViewController: UITableViewController {
    
    struct Containt {
        static let cellIdentifier = "cell"
    }
    
    lazy var menuSections: [MenuSection] = {
        // Presentation Transitions
        let crossDissolveItem = MenuItem(title: "Cross Dissolve",
                                         detail: "A cross dissolve transition.") { [weak self] in
            self?.showCrossDissolve()
        }
        
        let swipeItem = MenuItem(title: "Swipe",
                                 detail: "An interactive transition.") { [weak self] in
            self?.showSwipe()
        }
        
        let customPresentationItem = MenuItem(title: "Custom Presentation",
                                              detail: "Using a presentation controller to alter the layout of a presented view controller.") { [weak self] in
            self?.showCustomPresentation()
        }
        
        let adaptivePresentationItem = MenuItem(title: "Adaptive Presentation",
                                                detail: "Building a custom presentation that adapts to horizontally compact environments.") { [weak self] in
            self?.showAdaptivePresentation()
        }
        
        let presentationTransitions = MenuSection(title: "Presentation Transitions",
                                                  items: [crossDissolveItem,
                                                          swipeItem,
                                                          customPresentationItem,
                                                          adaptivePresentationItem])
        
        // Navigation Controller Transitions
        
        let checkerboardItem = MenuItem(title: "Checkerboard",
                                        detail: "Advanced animations with Core Animation.") { [weak self] in
            self?.showCheckerboard()
        }
        
        let navigationControllerTransitions = MenuSection(title: "Navigation Controller Transitions",
                                                          items: [checkerboardItem])
        
        // TabBar Controller Transitions
        
        let slideItem = MenuItem(title: "Slide",
                                 detail: "Interactive transitions with UITabBarController.") { [weak self] in
            self?.showSlide()
        }
        
        let tabBarControllerTransitions = MenuSection(title: "TabBar Controller Transitions",
                                                      items: [slideItem])
        
        return [presentationTransitions,
                navigationControllerTransitions,
                tabBarControllerTransitions]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - TableView data
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Containt.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Containt.cellIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        
        let item = menuSections[indexPath.section].items[indexPath.row]
        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.detail
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuSections[indexPath.section].items[indexPath.row]
        item.action()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuSections[section].title
    }
    
    
    // MARK: - show item
    
    func showCrossDissolve() {
        let viewController = CrossDissolveFirstViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func showSwipe() {
        let viewController = SwipeFirstViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func showCustomPresentation() {
        
    }
    
    func showAdaptivePresentation() {
        
    }
    
    func showCheckerboard() {
        
    }
    
    func showSlide() {
        
    }
}

