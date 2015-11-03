//
//  LocationController.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/19.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationController : NSObject

@property (strong, nonatomic) NSMutableArray *station;
@property (strong, nonatomic) NSMutableArray *time;

-(NSMutableArray *) getStation;
-(NSMutableArray *) getStationTime;
-(NSMutableArray *) getTimeArrival:(int)num;
//-(NSString *)staLan:(int)staNum;
@end
