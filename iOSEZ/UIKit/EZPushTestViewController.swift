//
//  EZPushTestViewController.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/6/9.
//

import Foundation
import UIKit

class EZPushTestViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(testPresentBtn)
        view.addSubview(testPushBtn)
        view.addSubview(testLayoutBtn)
        view.addSubview(testAddChildVCBtn)
        view.addSubview(testRemoveVCBtn)
        
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "view is load: \(isViewLoaded)")
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
        if let navc = navigationController {
            EZLogger.log(tag: "self", content: String(describing: self))
            EZLogger.log(tag: "top", content: String(describing: navc.topViewController))
            EZLogger.log(tag: "navc", content: String(describing: navc))
            EZLogger.log(tag: "visible", content: String(describing: navc.visibleViewController))
            EZLogger.log(tag: "children", content: String(describing: navc.children))
        }
        
        if let presentingVC = presentingViewController,
           let navc = presentingVC as? UINavigationController {
            EZLogger.log(tag: "self", content: String(describing: self))
            EZLogger.log(tag: "visible", content: String(describing: navc.visibleViewController))
        }
        
        if let presentingVC = presentingViewController {
            EZLogger.log(tag: "presenting", content: String(describing: presentingVC))
        }
//        if let lastNavc = presentingViewController?.navigationController {
//            EZLogger.log(tag: "self", content: String(describing: self))
//            EZLogger.log(tag: "top", content: String(describing: lastNavc.topViewController))
//            EZLogger.log(tag: "navc", content: String(describing: lastNavc))
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function)")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function) - parent: \(String(describing: parent)) - children: \(String(describing: navigationController?.children))")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "\(#function) - parent: \(String(describing: parent)) - children: \(String(describing: navigationController?.children))")
    }
    
    // MARK: - UI
    
    @objc private func presentVC() {
        let vc = EZPresentTestViewController()
        // test
//        vc.modalPresentationStyle = .popover
        
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalPresentationStyle = .currentContext
        
//        vc.modalPresentationStyle = .pageSheet
//        vc.modalPresentationStyle = .formSheet
        
        vc.modalPresentationStyle = .fullScreen
//        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc private func pushVC() {
//        if let navc = presentingViewController as? UINavigationController {
//            navc.pushViewController(EZPushTestViewController(), animated: true)
//        }
        if let navc = navigationController {
            // @ezrealzhang push 的动画有无会对整个生命周期有影响吗？
            navc.pushViewController(EZPresentTestViewController(), animated: true)
        }
    }
    
    // @ezrealzhang 研究下这种情况下的生命周期
    @objc private func addChildVC() {
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "1 \(#function) - parent: \(String(describing: presentTestVC.parent)) - children: \(self.children)")
        addChild(presentTestVC)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "2 \(#function) - parent: \(String(describing: presentTestVC.parent)) - children: \(self.children)")
        view.addSubview(presentTestVC.view)
        presentTestVC.didMove(toParent: self)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "3 \(#function) - parent: \(String(describing: presentTestVC.parent)) - children: \(self.children)")
    }
    
    @objc private func removeChildVC() {
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "4 \(#function) - parent: \(String(describing: presentTestVC.parent)) - children: \(self.children)")
        presentTestVC.willMove(toParent: nil)
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "5 \(#function) - parent: \(String(describing: presentTestVC.parent)) - children: \(self.children)")
        presentTestVC.view.removeFromSuperview()
        presentTestVC.removeFromParent()
        EZLogger.log(tag: "\(EZPushTestViewController.self)", content: "6 \(#function) - parent: \(String(describing: presentTestVC.parent)) - children: \(self.children)")
    }
    
    @objc private func layoutAgain() {
//        view.addSubview(UIView())
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//        view.frame.origin.y = 20
//        screen rotate
    }
    
    private lazy var presentTestVC: UIViewController = {
        let vc = EZPresentTestViewController()
        vc.view.frame = .init(x: 0, y: 400, width: 200, height: 200)
        vc.view.backgroundColor = .blue
        return vc
    }()
    
    private lazy var testPresentBtn: UIButton = {
        let testBtn = UIButton(frame: .init(x: 100, y: 100, width: 50, height: 50))
        testBtn.setTitle("present", for: .normal)
        testBtn.setTitleColor(.black, for: .normal)
        testBtn.addTarget(self, action: #selector(presentVC), for: .touchUpInside)
        return testBtn
    }()
   
    private lazy var testPushBtn: UIButton = {
        let testBtn = UIButton(frame: .init(x: 100, y: 200, width: 50, height: 50))
        testBtn.setTitleColor(.black, for: .normal)
        testBtn.setTitle("push", for: .normal)
        testBtn.addTarget(self, action: #selector(pushVC), for: .touchUpInside)
        return testBtn
    }()
    
    private lazy var testLayoutBtn: UIButton = {
         let testBtn = UIButton(frame: .init(x: 100, y: 300, width: 50, height: 50))
        testBtn.setTitleColor(.black, for: .normal)
        testBtn.setTitle("layout", for: .normal)
        testBtn.addTarget(self, action: #selector(layoutAgain), for: .touchUpInside)
        return testBtn
    }()
    
    private lazy var testAddChildVCBtn: UIButton = {
        let testBtn = UIButton(frame: .init(x: 200, y: 100, width: 50, height: 50))
        testBtn.setTitle("addChild", for: .normal)
        testBtn.setTitleColor(.black, for: .normal)
        testBtn.addTarget(self, action: #selector(addChildVC), for: .touchUpInside)
        return testBtn
    }()
   
    private lazy var testRemoveVCBtn: UIButton = {
        let testBtn = UIButton(frame: .init(x: 200, y: 200, width: 50, height: 50))
        testBtn.setTitleColor(.black, for: .normal)
        testBtn.setTitle("remove", for: .normal)
        testBtn.addTarget(self, action: #selector(removeChildVC), for: .touchUpInside)
        return testBtn
    }()
    
}
