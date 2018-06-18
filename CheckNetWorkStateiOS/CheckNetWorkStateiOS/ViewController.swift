//
//  ViewController.swift
//  CheckNetWorkStateiOS
//
//  Created by 平田 隼人 on 2018/06/18.
//  Copyright © 2018年 Hayato Hirata. All rights reserved.
//  ReachabilityはApple製のライブラリ
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    // オンラインチェック結果
    @IBOutlet var labelOnlineCheck: UILabel!
    // ネットワーク種別判定結果
    @IBOutlet var labelNetWorkTypeCheck: UILabel!
    // 電界強度取得結果
    @IBOutlet var labelNetStrengthCheck: UILabel!
    // 電波状況追跡結果
    @IBOutlet var labelSignalScout: UILabel!
    
    var reachability:Reachability!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reachability = Reachability.forInternetConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ボタンアクション：ONLINEチェック
    @IBAction func TouchOnlineCheck(_ sender: Any) {
        // 3G, LTEなどのPhoneネットワークを調査
        let netStatus:NetworkStatus = reachability.currentReachabilityStatus()
        var isReachable:Bool = false
        var netType:String = ""
        if(netStatus != NetworkStatus.NotReachable) {
            // ネット接続中
            isReachable = true
            if (netStatus == NetworkStatus.ReachableViaWiFi) {
                netType = "、種別：WiFi"
            } else {
                netType = "、種別：Phone"
            }
        }
//        ↓↓ 以下のメソッドは非推奨になった為、使用しない。
//        let wifiReachability:Reachability = Reachability.forLocalWiFi()
        // ONLINE判定
        if isReachable {
            self.labelOnlineCheck.text = "ONLINEです" + netType
        } else {
            self.labelOnlineCheck.text = "OFFLINEです" + netType
        }
    }
    // ボタンアクション：ネットワーク種別判定
    @IBAction func TouchNetWorkCheck(_ sender: Any) {
        self.labelNetWorkTypeCheck.text = "↑のONLINEチェックで、ネット有無と種別を一括取得できています"
    }
    // ボタンアクション：電界強度取得
    @IBAction func TouchNetStrengthCheck(_ sender: Any) {
        //let signalStrength:SignalStrength = SignalStrength.init()
        let result:Int32 = SignalStrength.check()
        print("SignalStrength:" + String(result))
        self.labelNetStrengthCheck.text = "電界強度は：" + String(result)
    }
    
    // ボタンアクション：電波状況追跡
    @IBAction func TouchSignalScout(_ sender: Any) {
        let notifiCenter:NotificationCenter = NotificationCenter.default
        notifiCenter.addObserver(self, selector: #selector(self.signalUpdate), name: NSNotification.Name.reachabilityChanged, object: nil)
        reachability.startNotifier()
        self.labelSignalScout.text = "追跡を開始しました"
    }
    
    // ボタンアクション：追跡解除
    @IBAction func TouchScoutCancel(_ sender: Any) {
        reachability.stopNotifier()
        let notifiCenter:NotificationCenter = NotificationCenter.default
        notifiCenter.removeObserver(self)
        self.labelSignalScout.text = "追跡を解除しました"
    }
    // 追跡メソッド；電波状況変更時
    func signalUpdate(notification:Notification?) {
        // 3G, LTEなどのPhoneネットワークを調査
        let netStatus:NetworkStatus = reachability.currentReachabilityStatus()
        var isReachable:Bool = false
        var netType:String = ""
        if(netStatus != NetworkStatus.NotReachable) {
            // ネット接続中
            isReachable = true
            if (netStatus == NetworkStatus.ReachableViaWiFi) {
                netType = "、種別：WiFi"
            } else {
                netType = "、種別：Phone"
            }
        }
        //        ↓↓ 以下のメソッドは非推奨になった為、使用しない。
        //        let wifiReachability:Reachability = Reachability.forLocalWiFi()
        // ONLINE判定
        if isReachable {
            self.labelSignalScout.text = "ONLINEです" + netType
        } else {
            self.labelSignalScout.text = "OFFLINEです" + netType
        }
    }
    
}

