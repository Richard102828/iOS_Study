//
//  EZGlobalConfig.swift
//  iOSEZ
//
//  Created by ezrealzhang on 2023/6/25.
//

import Foundation
import UIKit

var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    UIScreen.main.bounds.height
}

// @ezrealzhang todo 如果正确的获取一个状态栏的高度？
var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}
