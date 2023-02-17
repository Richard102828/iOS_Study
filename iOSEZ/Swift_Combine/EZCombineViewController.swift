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
        return button
    }()
    
    private let viewModel: RegisterCombineViewModel = {
        return RegisterCombineViewModel()
    }()
    
    // @ezrealzhang 持有 cancelable 对象，保证流程中的 publisher 不会被释放掉
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
        viewModel.registerValuePublisher().sink { enable in
            self.registerBtn.isEnabled = enable
        }.store(in: &cancelableCollection)
    }
    
   @objc private func showRegisterTip() {
       SVProgressHUD.showInfo(withStatus: "注册成功")
    }
}














// @ezrealzhang 实例 1 - URLSession

func makeRequest() {
    let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: "xxx")!)
    let cancelable = publisher
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

// @ezrealzhang 实例 2 - 登陆注册




func test2<T>(vc: T) where T: EZCombineViewController {
    
}

func test<T: EZCombineViewController>(vc: T) {
    
}

func test1(vc: some EZCombineViewController) {
    
}



// @ezrealzhang publisher

extension Publishers {
    
}
