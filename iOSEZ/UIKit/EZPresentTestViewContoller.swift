//
//  EZPresentTestViewContoller.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/6/9.
//

import Foundation
import UIKit

class EZPresentTestViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function)")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function) - parent: \(String(describing: parent)) - children: \(self.children)")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function) - parent: \(String(describing: parent)) - children: \(self.children)")
    }
    
    private func setupNavigationBar() {
        let top = statusBarHeight != 0 ? statusBarHeight : 44
        let bar = UINavigationBar.init(frame: .init(x: 0, y: top, width: screenWidth, height: screenHeight))
        let item = UINavigationItem.init(title: "present test")
        item.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        bar.pushItem(item, animated: false)
        view.addSubview(bar)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
}
