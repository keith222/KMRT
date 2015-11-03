//
//  StationInfoViewController.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/2/18.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StationInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property int staNum, staSection;
@property (strong, nonatomic) NSMutableArray *toiletArray;
@property (strong, nonatomic) NSMutableArray *elevatorArray;
@property (strong, nonatomic) NSMutableArray *bikeArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *staNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *staNameEngLabel;
@property (strong, nonatomic) IBOutlet UIImageView *staImgView;
@property (strong, nonatomic) IBOutlet UIImageView *staInfoImgView;
@property AppDelegate *app;

@end
