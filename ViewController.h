//
//  ViewController.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/19.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    CLLocation *tempLocation;
    
    MBProgressHUD *HUD;
    AppDelegate *app;
    
    int num;
    NSTimer *timer;
    NSString *currentLanguage;
    NSArray *languages;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *contentScroll;

@property (strong, nonatomic) IBOutlet UILabel *staName;
@property (strong, nonatomic) IBOutlet UILabel *staEngName;
@property (strong, nonatomic) IBOutlet UIImageView *staMarkView;

@property (strong, nonatomic) IBOutlet UIView *directNW;
@property (strong, nonatomic) IBOutlet UIView *directSE;
@property (strong, nonatomic) IBOutlet UIView *ForDirW;
@property (strong, nonatomic) IBOutlet UIView *ForDirE;

@property (strong, nonatomic) IBOutlet UILabel *terminalNW;
@property (strong, nonatomic) IBOutlet UILabel *terminalSE;
@property (strong, nonatomic) IBOutlet UILabel *terminalForW;
@property (strong, nonatomic) IBOutlet UILabel *terminalForE;

@property (strong, nonatomic) IBOutlet UILabel *minNW;
@property (strong, nonatomic) IBOutlet UILabel *minSE;
@property (strong, nonatomic) IBOutlet UILabel *minsForW;
@property (strong, nonatomic) IBOutlet UILabel *minsForE;

@property (strong, nonatomic) IBOutlet UILabel *toNW;
@property (strong, nonatomic) IBOutlet UILabel *toSE;
@property (strong, nonatomic) IBOutlet UILabel *minOne;
@property (strong, nonatomic) IBOutlet UILabel *minTwo;
@property (strong, nonatomic) IBOutlet UILabel *toForW;
@property (strong, nonatomic) IBOutlet UILabel *minForW;
@property (strong, nonatomic) IBOutlet UILabel *toForE;
@property (strong, nonatomic) IBOutlet UILabel *minForE;

@end
