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

// @ezrealzhang 问题 1 ：能不能直接用 AnyPublisher<UIControl, Never> 这样呢？这样就没指定 subscription 来连接了？
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
