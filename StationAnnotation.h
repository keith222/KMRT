//
//  StationAnnotation.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/26.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StationAnnotation : NSObject <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:(NSString *)argTitle subtitle:(NSString *)argSubtitle image:(NSString *)argImage;

@property (strong,nonatomic) NSString *imageName;
@end
