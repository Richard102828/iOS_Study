//
//  EZTACViewController.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/5/6.
//

import Foundation
import UIKit
import Combine
import ComposableArchitecture


/**
 feature
    - 一个显示数字以及递增和递减数字的“+”和“-”按钮的UI。还有一个按钮键，当点击该按钮时，它会发出API请求以获取有相关数字的随机事件，然后在 alert 中显示该事件
 feel
    - 确实流程十分的清晰
    - 如果想在网络请求前后做一些操作怎么处理？
        - 感觉只有抽出去再外面做处理了，网络请求感觉不适合放在里面？
 */
class EZTCAViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // @ezrealzhang test，持有一下
    private let store: Store<Feature.State, Feature.Action>
    
    init() {
        let reducer = Feature()
        let state = Feature.State()
        store = StoreOf<Feature>(initialState: state, reducer: reducer)
        viewStore = ViewStoreOf<Feature>(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(addBtn)
        view.addSubview(subBtn)
        view.addSubview(button)
        commonInit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRectMake((view.frame.width - 50) * 0.5, 200, 100, 50)
        addBtn.frame = CGRectMake((view.frame.width - 120) * 0.5, label.frame.origin.y + 50, 100, 50)
        subBtn.frame = CGRectMake(addBtn.frame.origin.x + addBtn.frame.width + 20, label.frame.origin.y + 50, 100, 50)
        button.frame = CGRectMake((view.frame.width - 50) * 0.5, subBtn.frame.origin.y + 50, 100, 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // test
        let task = Task.detached {
            await self.testFeature()
        }
    }
    
    private func commonInit() {
        addActions()
        // num display
        viewStore.publisher
            .dropFirst()
            .handleEvents(receiveSubscription: { _ in
                print("ezez 1 subscription")
            }, receiveOutput: { _ in
                print("ezez 1 receive value")
            })
            .map { "\($0.count)" }
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
        
        // alert display
        viewStore.publisher.alertText
            .dropFirst()
            .handleEvents(receiveSubscription: { _ in
                print("ezez 2 subscription")
            }, receiveOutput: { _ in
                print("ezez 2 receive value")
            })
            .sink { [weak self] alertText in
                let alertController = UIAlertController(title: alertText, message: nil, preferredStyle: .alert)
                alertController.addAction(
                    UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: { _ in
                            self?.viewStore.send(.alertDismissTapped)
                        }
                    )
                )
                self?.present(alertController, animated: true, completion: nil)
            }.store(in: &cancellables)
    }
    
    // MARK: - test
    
    func testFeature() async {
        let store = TestStore(initialState: Feature.State(), reducer: Feature())
        await store.send(.addBtnTapped) { state in
            // 一次 add 之后，应该从 0 变为 1，否则会触发断言，下面的类似
            state.count = 1
        }
        
        await store.send(.subBtnTapped) { state in
            state.count = 0
        }
    }
    
    // MARK: - actions
    
    private func addActions() {
        addBtn.addTarget(self, action: #selector(addBtnTappedAction), for: .touchUpInside)
        subBtn.addTarget(self, action: #selector(subBtnTappedAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTappedAction), for: .touchUpInside)
    }
    
    @objc private func addBtnTappedAction() {
        viewStore.send(.addBtnTapped)
    }
    
    @objc private func subBtnTappedAction() {
        viewStore.send(.subBtnTapped)
    }
    
    @objc private func buttonTappedAction() {
        viewStore.send(.buttonTapped)
    }
    
    // MARK: - getters
    
    private let viewStore: ViewStoreOf<Feature>
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "num"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .blue
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let addBtn: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("add", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let subBtn: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("sub", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("alert", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
}


struct Feature: ReducerProtocol {
    
    /**
     State 数据
        1. count
        2. alertText
     */
    struct State: Equatable {
        var count = 0
        var alertText: String?
    }
    
    /**
     Action 所有操作（细分）：思考每一个操作可能回带来的其他额外的操作 - 包括网络请求 response 也算
        1. stepper + tap
        2. stepper - tap
        3. button tap - 该操作带来额外的操作
            a. request response
            b. alert dismiss tap
     */
    enum Action: Equatable {
        case addBtnTapped
        case subBtnTapped
        case buttonTapped
        case buttonRequestResponded(TaskResult<String>)
        case alertDismissTapped
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        print("ezez - reduce")
        switch action {
        case .addBtnTapped:
            state.count += 1
            return .none
        case .subBtnTapped:
            state.count -= 1
            return .none
        case .buttonTapped:
            return .task { [count = state.count] in
                await .buttonRequestResponded(
                    TaskResult {
                        String(decoding: try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)/trivia")!).0,
                               // @ezrealzhang 类型.self 是？
                               as: UTF8.self)
                    }
                )
            }
        case let .buttonRequestResponded(.success(text)):
            state.alertText = text
            return .none
        case .buttonRequestResponded(.failure):
            state.alertText = "请求出错"
            return .none
        case .alertDismissTapped:
            state.alertText = "dismiss alert"
            return .none
        }
    }
    
}

// 1. 一个是 依赖项 的处理
// 2. 还有一个是 下面这种处理方式，body 怎么用？

/**
 @ezrealzhang 这里不是很懂
 最好使用这些依赖项的模拟版本，以便用户可以在完全受控制的环境中与您的功能进行交互。
 这种情况下，您可以通过更改 reducer 的依赖项来实现这一点。例如，您可以为新手引导 reducer 提供模拟版本的依赖项，而为其他 reducer 提供真实的依赖项。这样，当用户在新手引导体验中与您的功能进行交互时，您可以确保不会对真实的数据或设置进行任何更改。
 */
//struct Onborading: ReducerProtocol {
//
//    var body: some ReducerProtocol<State, Action> {
//        Reduce { state, action in
//            // Additional onboarding logic
//        }
//        Feature()
//            .dependency(\.userDefaults, .mock)
//            .dependency(\.database, .mock)
//    }
//}
