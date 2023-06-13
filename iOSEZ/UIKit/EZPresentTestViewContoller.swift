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
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function) - parent: \(String(describing: parent))")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        EZLogger.log(tag: "\(EZPresentTestViewController.self)", content: "\(#function) - parent: \(String(describing: parent))")
    }
    
}
