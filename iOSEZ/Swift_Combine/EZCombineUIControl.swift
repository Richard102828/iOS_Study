//
//  EZCombineUIControl.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/17.
//

import Foundation
import Combine
import UIKit

// MARK: - UIControl 的 Publisher

// @ezrealzhang 理解一下这部分
extension Publishers {
    // subscrption
    private final class UIControlSubscription<S: Subscriber, C: UIControl> : Subscription where S.Input == C, S.Failure == Never {
       
        private var subscriber : S?
        private let control: C
        private let event: C.Event
        
        init(subscriber: S, control: C, event: C.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            self.control.addTarget(self, action: #selector(processControlEvent), for: self.event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            // nothing 对 control 的事件，直接处理
            // @ezrealzhang 可以对 demand 进行处理，来控制发布（如：demand >= Subscribers.Demand.none）
            // @ezrealzhang Publisher 到底是怎么发布值到 Subscriber 的？
            // @ezrealzhang 对应一般的值类型，不会就是在这里做 receive 操作的吧？那对于 Future 是怎么处理的？
        }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc func processControlEvent() {
            _ = subscriber?.receive(control)
        }
    }
    
    // publisher
    struct UIControlPublisher<C: UIControl> : Publisher {
        typealias Output = C
        typealias Failure = Never
        
        let control: C
        let event: C.Event
            
        init(control: C, event: C.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, C == S.Input {
            let subscrption = UIControlSubscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscrption)
        }
    }
    
}

// UIControl extension publisher

extension UIControl {
    func eventPublisher(event: UIControl.Event) -> Publishers.UIControlPublisher<UIControl> {
        return Publishers.UIControlPublisher(control: self, event: event)
    }
}

extension UITextField {
    func textChangePublisher() -> AnyPublisher<String?, Never> {
        return Publishers.UIControlPublisher(control: self, event: .editingChanged)
            .map { $0.text }
            .eraseToAnyPublisher()
    }
}

extension UISwitch {
    func valueChangePublisher() -> AnyPublisher<Bool, Never> {
        return Publishers.UIControlPublisher(control: self, event: .valueChanged)
            .map { $0.isOn }
            .eraseToAnyPublisher()
    }
}

extension UISlider {
    func valueChangePublisher() -> AnyPublisher<Float, Never> {
        return Publishers.UIControlPublisher(control: self, event: .valueChanged)
            .map { $0.value }
            .eraseToAnyPublisher()
    }
}
