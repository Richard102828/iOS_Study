//
//  EZCombineViewController.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/14.
//

import Foundation
import UIKit
import Combine
import SVProgressHUD

class EZCombineViewController: UIViewController {
    private let userNameTextField: UITextField = {
        let textFeild = UITextField.init(frame: CGRectZero)
        textFeild.placeholder = "用户名"
        return textFeild
    }()
    private let passwordTextField: UITextField = {
        let textFeild = UITextField.init(frame: CGRectZero)
        textFeild.placeholder = "密码"
        return textFeild
    }()
    private let confirmPasswordTextField: UITextField = {
        let textFeild = UITextField.init(frame: CGRectZero)
        textFeild.placeholder = "确认密码"
        return textFeild
    }()
    private let acceptSwitch: UISwitch = {
        let acceptSwitch = UISwitch.init(frame: CGRectZero)
        return acceptSwitch
    }()
    private lazy var registerBtn: UIButton = {
        let button = UIButton.init(frame: CGRectZero)
        button.setTitle("注册", for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        button.addTarget(self, action: #selector(showRegisterTip), for: .touchUpInside)
        button.eventPublisher(event: .touchUpInside).sink { _ in
            print("ezez 1212")
        } receiveValue: { _ in
            print("ezez 2121")
        }.store(in: &cancelableCollection)

        return button
    }()
    
    private let viewModel: RegisterCombineViewModel = {
        return RegisterCombineViewModel()
    }()
    
    // @ezrealzhang 持有 cancelable 对象，保证流程中的 publisher 不会被释放掉
    // @ezrealzhang 这块可以改造成与当前 vc 生命周期相绑定的逻辑，类似 android 的 live data
    private var cancelableCollection: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // views
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(acceptSwitch)
        view.addSubview(registerBtn)
        
        bindView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // frame
        userNameTextField.frame = CGRect.init(x: 100, y: 100, width: 200, height: 50)
        passwordTextField.frame = CGRect.init(x: 100, y: 150, width: 200, height: 50)
        confirmPasswordTextField.frame = CGRect.init(x: 100, y: 200, width: 200, height: 50)
        acceptSwitch.frame = CGRect.init(x: 100, y: 250, width: 200, height: 50)
        registerBtn.frame = CGRect.init(x: 100, y: 300, width: 200, height: 50)
    }
    
    private func bindView() {
        userNameTextField.textChangePublisher().sink { value in
            self.viewModel.userName = value
        }.store(in: &cancelableCollection)
        passwordTextField.textChangePublisher().sink { value in
            self.viewModel.password = value
        }.store(in: &cancelableCollection)
        confirmPasswordTextField.textChangePublisher().sink { value in
            self.viewModel.confirmPassword = value
        }.store(in: &cancelableCollection)
        acceptSwitch.valueChangePublisher().sink { isOn in
            self.viewModel.accept = isOn
        }.store(in: &cancelableCollection)
        // enable
        // @ezrealzhang 这里会执行一次，感觉就跟 promise 一样，创建的时候会执行
        viewModel.registerValuePublisher().sink { enable in
//            self.registerBtn.isEnabled = enable
            self.registerBtn.isEnabled = true
        }.store(in: &cancelableCollection)
        
        // test
        viewModel.$userName.sink { completion in
            print("completion: \(completion)")
        } receiveValue: { value in
            print("userName: \(String(describing: value))")
        }.store(in: &cancelableCollection)

    }
    
    let testIns = PublisherTest()
    @objc private func showRegisterTip() {
        SVProgressHUD.showInfo(withStatus: "注册成功")
        // @ezrealzhang 后面整理代码的时候移出去，现在先把学习的任务完成，后面再来整理项目
        
//        testIns.connectPublisherTest()
        //       PublisherTest().notificationTest()
        //       NotificationCenter.default.post(name: .init(rawValue: "checkSubscriptions"), object: nil)
        
//        testIns.backPressureTest()
//        testIns.timerTest()
//        testIns.valueSubject?.sink(receiveValue: { value in
//            print("\(value)")
//        }).store(in: &cancelableCollection)
//        testIns.currentValueSubject()
//        testIns.futureCallbackTest()
//        testIns.testDeferred()
//        testIns.shareDeferredTest()
//        testIns.multicaseTest()
//        testIns.asSubscriber()
//        testIns.emptyTest()
//        testIns.sequenceTest()
//        testIns.recordTest()
//        testIns.operatorsTest()
//        testIns.switchToLatestTest()
        testIns.justTest()
    }
}

// @ezrealzhang 实例 1 - URLSession

func makeRequest() {
    let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: "xxx")!)
    _ = publisher
        .receive(on: RunLoop.main)
        .sink { completion in
        switch completion {
        case .finished:
            print("完成")
        case .failure(_):
            print("出错")
        }
    } receiveValue: { value in
        print(value.data)
        print(value.response)
    }
}

// @ezrealzhang 实例 2 - Timer

func test2<T>(vc: T) where T: EZCombineViewController {
    
}

func test<T: EZCombineViewController>(vc: T) {
    
}

func test1(vc: some EZCombineViewController) {
    
}



// @ezrealzhang publisher

extension Publishers {
    
}
