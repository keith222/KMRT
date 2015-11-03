//
//  StationInfoMap.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2015/10/25.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

#import "StationInfoMap.h"
#import "StationAnnotation.h"

@implementation StationInfoMap

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    _stationArray = [_app.lc getStation];//取得車站列表
    _annotationArray = [[NSMutableArray alloc]init];//annotation陣列初始化
    geocoder = [[CLGeocoder alloc]init];
    
    stationLocation = CLLocationCoordinate2DMake([[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Latitude"]floatValue], [[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Longitude"]floatValue]);//取得最近車站經緯度
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(stationLocation, 200, 200);
    [self.staInfoMap setRegion:viewRegion animated:YES];//設定地圖可視範圍
    
    
    coordinate.latitude = [[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Latitude"]floatValue];
    coordinate.longitude = [[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Longitude"]floatValue];
    NSString *title = [NSString stringWithFormat:@"%@ %@",[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Num"],[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Station"]];
    StationAnnotation *annotation = [[StationAnnotation alloc]initWithCoordinate:coordinate title:title subtitle:[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Station_Eng"] image:[[_stationArray objectAtIndex:_selectNum]objectForKey:@"Num"] ];
    
    [self.staInfoMap addAnnotation:annotation];
    [_annotationArray addObject:annotation];
    
}

- (MKAnnotationView *) mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>) annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }//進入地圖時將所有infowindow清掉
    
    static NSString *AnnotationViewID = @"annotationViewID";
    MKAnnotationView *customPinView = (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (!customPinView) {
        customPinView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        customPinView.canShowCallout = YES;
        customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    StationAnnotation *stAnn = (StationAnnotation *)annotation;//設定各站 Map Pin
    if ([stAnn.imageName isEqualToString:@"O5"] || [stAnn.imageName isEqualToString:@"R10"]) {
        stAnn.imageName = @"R10O5";
    }
    NSString *imageName = [@"pin-" stringByAppendingString:stAnn.imageName];
    NSString *leftImageName = [@"sta-map-" stringByAppendingString:stAnn.imageName];
    customPinView.image = [UIImage imageNamed:imageName];
    customPinView.leftCalloutAccessoryView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImageName]];
    
    return customPinView;
    
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
/*    StationInfoViewController *contorller = [self.storyboard instantiateViewControllerWithIdentifier:@"StationInfo"];
    contorller.staNum = (int)[self.annotationArray indexOfObject:view.annotation];
    [self.navigationController pushViewController:contorller animated:YES];
  */  
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    UIView *stationTime = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-150, -80, 300, 50)];
    stationTime.backgroundColor = [UIColor whiteColor];
    stationTime.tag = 1;
    [self.view addSubview:stationTime];
    UIImageView *staImage;
    
    if ([view.annotation isKindOfClass:[StationAnnotation class]]) {
        StationAnnotation *annot = view.annotation;
        _staNum = (int)[self.annotationArray indexOfObject:annot];
        
        NSString *staImageName = [@"sta-map-" stringByAppendingString:[[_stationArray objectAtIndex:_staNum]objectForKey:@"Num"]];
        if ([staImageName isEqualToString:@"sta-map-O5"] || [staImageName isEqualToString:@"sta-map-R10"]) {
            staImageName = @"sta-map-R10O5";
        }
        staImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:staImageName]];
        staImage.frame = CGRectMake(20, (stationTime.frame.size.height/2)-(staImage.frame.size.height/2), staImage.frame.size.width, staImage.frame.size.height);
        [stationTime addSubview:staImage];
    }
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view viewWithTag:1].frame  = CGRectMake([self.view viewWithTag:1].frame.origin.x, -80, [self.view viewWithTag:1].frame.size.width,[self.view viewWithTag:1].frame.size.height);
    } completion:^(BOOL finished){
        [[self.view viewWithTag:1] removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
