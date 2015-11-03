//
//  AppDelegate.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/19.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    int globalStaNum; //設定全域變數用作儲存最近車站編號
    LocationController *lc;
}

@property (strong, nonatomic) UIWindow *window;
@property int globalStaNum;//property全域變數
@property LocationController *lc;

@end
