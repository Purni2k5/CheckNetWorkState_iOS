//
//  SignalStrength.swift
//  CheckNetWorkStateiOS
//
//  Created by 平田 隼人 on 2018/07/04.
//  Copyright © 2018年 Hayato Hirata. All rights reserved.
//

import Foundation

class SignalStrength {
    /* 強度は実数で取得(大体..弱 -120 ~ -30 強) */
    static func check() -> Int {
        let app = UIApplication.shared
        // WiFiビュー
        let uiStatusBarDataNetworkItemView: AnyClass = NSClassFromString("UIStatusBarDataNetworkItemView")!
        var signalVal_wifi = 0;
        // Carrierビュー
        let uiStatusBarSignalStrengthItemView: AnyClass = NSClassFromString("UIStatusBarSignalStrengthItemView")!
        var signalVal_carrier  = 0;

        let exception = tryBlock {
            //ビューからステータスバー取得
            guard let statusBar = app.value(forKey: "statusBar") as? UIView else { return }
            if let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), statusBar .isKind(of: statusBarMorden) { return }
            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return  }
            //取得したステータスバーから、WiFi及びCarrierの電波強度取得
            for view in foregroundView.subviews {
                // WiFi強度取得
                if view.isKind(of: uiStatusBarDataNetworkItemView) {
                    if let val = view.value(forKey: "wifiStrengthRaw") as? Int {
                        signalVal_wifi = val
                    }
                }
                // Carrier強度取得
                if view.isKind(of: uiStatusBarSignalStrengthItemView) {
                    if let val = view.value(forKey: "signalStrengthRaw") as? Int {
                        signalVal_carrier = val
                    }
                }
            }
        }
        if let exception = exception {
            print("SignalStrength.check exception: \(exception)")
        }
        // WiFi及びCarrierのうち、強度の強い方を返却
        if signalVal_carrier < 0 && signalVal_wifi < 0 {
            return signalVal_carrier > signalVal_wifi ? signalVal_carrier : signalVal_wifi
        } else if signalVal_carrier < 0 {
            return signalVal_carrier
        } else if signalVal_wifi < 0 {
            return signalVal_wifi
        } else { // 異常時
            return 0;
        }
    }
    
    /* iPhoneX専用 電波強度取得 */
    /* 強度は実数で取得(大体..弱 -120 ~ -30 強) */
    static func checkForX() -> Int {
        let app = UIApplication.shared
        // WiFiビュー
        let uiStatusBarWifiSignalView: AnyClass = NSClassFromString("_UIStatusBarWifiSignalView")!
        var signalVal_wifi = 0;
        // Carrierビュー
        let uiStatusBarCarrierSignalView: AnyClass = NSClassFromString("_UIStatusBarCellularSignalView")!
        var signalVal_carrier  = 0;
        
        let exception = tryBlock {
            //ビューからステータスバー取得
            guard let statusBar = app.value(forKey: "statusBar") as? UIView else { return }
            if let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), statusBar .isKind(of: statusBarMorden) { return }
            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return  }
            //取得したステータスバーから、WiFi及びCarrierの電波強度取得
            for view in foregroundView.subviews {
                for v in view.subviews {
                    // WiFi強度取得
                    if v.isKind(of: uiStatusBarWifiSignalView) {
                        if let val = v.value(forKey: "numberOfActiveBars") as? Int {
                            signalVal_wifi = val
                            break
                        }
                    }
                    // Carrier強度取得
                    if view.isKind(of: uiStatusBarCarrierSignalView) {
                        if let val = view.value(forKey: "_numberOfActiveBars") as? Int {
                            signalVal_carrier = val
                        }
                    }
                }
            }
        }
        if let exception = exception {
            print("SignalStrength.checkForX exception: \(exception)")
            return 0; // 異常時の値
        }
        // WiFi及びCarrierのうち、強度の強い方を返却
        if signalVal_carrier < 0 && signalVal_wifi < 0 {
            return signalVal_carrier > signalVal_wifi ? signalVal_carrier : signalVal_wifi
        } else if signalVal_carrier < 0 {
            return signalVal_carrier
        } else if signalVal_wifi < 0 {
            return signalVal_wifi
        } else { // 異常時
            return 0;
        }
    }
}

