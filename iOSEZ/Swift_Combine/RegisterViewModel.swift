//
//  RegisterViewModel.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/17.
//

import Foundation
import Combine

class RegisterCombineViewModel : NSObject {
    @Published @objc dynamic var userName: String?
    @Published var password: String?
    @Published var confirmPassword: String?
    @Published var accept: Bool = false
    
    func registerValuePublisher() -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4($userName, $password, $confirmPassword, $accept)
            .map { (userName, password, confirmPassword, accept) -> Bool in
                guard let a = userName, let b = password, let c = confirmPassword else {
                    return false
                }
                
                return a.count > 5
                    && b.count > 2
                    && b == c
                    && accept
            }.eraseToAnyPublisher()
    }
}
