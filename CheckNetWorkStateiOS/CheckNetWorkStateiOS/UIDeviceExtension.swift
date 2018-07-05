//
//  UIDeviceExtension.swift
//  CheckNetWorkStateiOS
//
//  Created by 平田 隼人 on 2018/07/04.
//  Copyright © 2018年 Hayato Hirata. All rights reserved.
//

import Foundation

private let DeviceList = [
    /* iPod 5 */
    "iPod5,1": "iPod Touch 5",
    /* iPhone 4 */
    "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    /* iPhone 4S */
    "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */        
    "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    /* iPhone 5C */
    "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    /* iPhone 5S */
    "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */
    "iPhone7,2": "iPhone 6",
    /* iPhone 6 Plus */
    "iPhone7,1": "iPhone 6 Plus",
    /* iPhoneX */
    "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X",
    /* iPad 2 */
    "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */
    "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */
    "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad Air */
    "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */
    "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Mini */
    "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */
    "iPad4,4": "iPad Mini", "iPad4,5": "iPad Mini", "iPad4,6": "iPad Mini",
    /* iPad Mini 3 */
    "iPad4,7": "iPad Mini", "iPad4,8": "iPad Mini", "iPad4,9": "iPad Mini",
    /* Simulator */
    "x86_64": "Simulator", "i386": "Simulator"
]

// 端末サイズの縦幅
fileprivate let DEVICE_HEIGHT_35: CGFloat = 480; // 4系(iPad互換)
fileprivate let DEVICE_HEIGHT_58: CGFloat = 812; // X

extension UIDevice {
    
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""
        
        for i in mirror.children {
            if let value = i.value as? Int8, value != 0 {
                let str = String(Unicode.Scalar(UInt8(value)))
                identifier.append(str)
            }
        }
        return DeviceList[identifier] ?? identifier
    }
    
    var isiPhoneX: Bool {
        if safeAreaBottomInset() > 0 {
            return true
        }
        
        if userInterfaceIdiom == .phone && getDeviceScreenHeight() == DEVICE_HEIGHT_58 {
            return true
        }
        return false
    }
    
    fileprivate func safeAreaBottomInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    // 端末サイズ(高さ)取得 iPhone5(568), iPhone6(667), iPhone6 plus,(716)、iPad互換(480)
    fileprivate func getDeviceScreenHeight() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        return screenSize.height
    }
}
