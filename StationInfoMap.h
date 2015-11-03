//
//  StationInfoMap.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2015/10/25.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface StationInfoMap : UIViewController<MKMapViewDelegate>{
    CLGeocoder *geocoder;
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D stationLocation;
}

@property (strong,nonatomic) IBOutlet MKMapView *staInfoMap;
@property (strong,nonatomic) NSMutableArray *stationArray;
@property (strong, nonatomic) NSMutableArray *annotationArray;

@property int selectNum;
@property int staNum;

@property AppDelegate *app;
@end
