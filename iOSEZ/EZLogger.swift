//
//  EZLogger.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/6/9.
//

import Foundation

@objc class EZLogger: NSObject {
    @objc static func log(tag: String, content: String) {
        print("[\(tag)]: - \(content)")
    }
}
