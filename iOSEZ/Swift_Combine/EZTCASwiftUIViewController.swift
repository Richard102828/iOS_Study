//
//  EZTCASwiftUIViewController.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/5/15.
//

import Foundation
import UIKit
import SwiftUI

class EZTCASwiftUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swift ui test
        let mySwiftUIView = TCAContentView()
        let hostingController = UIHostingController(rootView: mySwiftUIView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}
