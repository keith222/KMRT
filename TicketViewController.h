//
//  TicketViewController.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/20.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TicketViewController : UIViewController  <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIView *tickeTime;
@property (strong, nonatomic) IBOutlet UIView *tripProcess;
@property (strong, nonatomic) NSMutableArray *stationList;
@property int btnTag;
@property int countNum;
@property int nowStaNumf,nowStaNumt;
@property AppDelegate *app;
@end
