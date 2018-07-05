//
//  SignalStrength.m
//  CheckNetWorkStateiOS
//
//  Created by 平田 隼人 on 2018/06/18.
//  Copyright © 2018年 Hayato Hirata. All rights reserved.
//

#import "bkSignalStrength.h"
@implementation bkSignalStrength

//- (id)init
//{
//    return self;
//}

// Swiftクラスで実装しようとした所、文法上、valueForKeyの連続使用が出来なかった為、obj-cにて実装
// 戻り値：
//   異常時：0
// 参考値：
//   強 -45 ~ -130 弱
//   carrier:  要調査
//   wifi   :バリ3時に取得で-51だった。
+ (int) check
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *carrierSignalStrengthItemView = nil;
    NSString *wifiSignalStrengthItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
            carrierSignalStrengthItemView = subview;
        }
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            wifiSignalStrengthItemView = subview;
        }
    }
    // 取得できなかった場合、値は0が入る
    int carrierSignalStrength = [[carrierSignalStrengthItemView valueForKey:@"signalStrengthRaw"] intValue];
    int wifiSignalStrength = [[wifiSignalStrengthItemView valueForKey:@"wifiStrengthRaw"] intValue];
    if(carrierSignalStrength != 0) {
        return carrierSignalStrength;
    } else if (wifiSignalStrength != 0) {
        return wifiSignalStrength;
    } else { // 異常時
        return 0;
    }
}
@end
