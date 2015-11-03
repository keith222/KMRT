//
//  LocationController.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/19.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import "LocationController.h"
#import "ViewController.h"

@implementation LocationController

-(NSMutableArray *)getStation{//取得車站列表
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"kmrt" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    _station = [[NSMutableArray alloc]init];
    _station = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return _station;
}

-(NSMutableArray *) getStationTime{//取得旅行時間
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"kmrt_station_time" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    _time = [[NSMutableArray alloc]init];
    _time = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return _time;
}

-(NSMutableArray *) getTimeArrival:(int)num{//取得KaohsiungOpenData 上的高捷即時到站時間
    NSMutableArray *minuteInfo = [[NSMutableArray alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%d", @"http://data.kaohsiung.gov.tw/Opendata/MrtJsonGet.aspx?site=", num];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //將Kaohsiung Opendata Json中的html tag清掉，平台修好後以下可註解
    NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSRange range;
    while ((range = [newStr rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@""];
    }
    response = [newStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *minute = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *minuteDetail = [minute objectForKey:@"MRT"];
    
    if (minuteDetail != NULL) {
        [minuteInfo addObject:minuteDetail];
        return minuteInfo;
    }else{
        return NULL;
    }
}




@end
