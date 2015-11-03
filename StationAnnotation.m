//
//  StationAnnotation.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/26.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import "StationAnnotation.h"

@implementation StationAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:(NSString *)argTitle subtitle:(NSString *)argSubtitle image:(NSString *)argImage{
    self = [super self];
    if(self){
        coordinate = argCoordinate;//MapViewController傳過來的站點經緯度
        title = argTitle;//infoWindow 的標題
        subtitle = argSubtitle;//infoWindow 的副標題
        _imageName = argImage;//infoWindow 站標
    }
    return self;
}
@end
