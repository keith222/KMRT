//
//  MapViewController.h
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/20.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>{
    CLGeocoder *geocoder;
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D stationLocation;
}

@property (strong, nonatomic) NSMutableArray *stationArray;
@property (strong, nonatomic) NSMutableArray *annotationArray;
@property int staNum;

@property (strong, nonatomic) IBOutlet MKMapView *stationPoint;
@property (strong, nonatomic) IBOutlet UILabel *fTime;
@property (strong, nonatomic) IBOutlet UILabel *sTime;
@property (strong, nonatomic) IBOutlet UILabel *tTime;
@property (strong, nonatomic) IBOutlet UILabel *frTime;
@property (strong, nonatomic) NSTimer *timer;

@property int nearStationNum;
@property int selectNum;
@property int checkNum;

-(IBAction)locateMe:(id)sender;

@property AppDelegate *app;


@end
