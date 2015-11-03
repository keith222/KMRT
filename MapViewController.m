//
//  MapViewController.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/20.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import "MapViewController.h"
#import "StationAnnotation.h"
#import "StationInfoViewController.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    _nearStationNum = _app.globalStaNum; //存取全域變數儲存的最近車站編號
    
    self.stationPoint.delegate = self;
    self.stationPoint.showsUserLocation = YES;//顯示使用者所在
    
    _stationArray = [_app.lc getStation];//取得車站列表
    _annotationArray = [[NSMutableArray alloc]init];//annotation陣列初始化
    geocoder = [[CLGeocoder alloc]init];
    

    stationLocation = CLLocationCoordinate2DMake([[[_stationArray objectAtIndex:_nearStationNum]objectForKey:@"Latitude"]floatValue], [[[_stationArray objectAtIndex:_nearStationNum]objectForKey:@"Longitude"]floatValue]);//取得最近車站經緯度
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(stationLocation, 800, 800);
    [self.stationPoint setRegion:viewRegion animated:YES];//設定地圖可視範圍
    
    for (int i = 0; i < [_stationArray count]; i++) {//將站點經緯、標題、副標題、站標圖片傳至mapannotation
        coordinate.latitude = [[[_stationArray objectAtIndex:i]objectForKey:@"Latitude"]floatValue];
        coordinate.longitude = [[[_stationArray objectAtIndex:i]objectForKey:@"Longitude"]floatValue];
        NSString *title = [NSString stringWithFormat:@"%@ %@",[[_stationArray objectAtIndex:i]objectForKey:@"Num"],[[_stationArray objectAtIndex:i]objectForKey:@"Station"]];
        StationAnnotation *annotation = [[StationAnnotation alloc]initWithCoordinate:coordinate title:title subtitle:[[_stationArray objectAtIndex:i]objectForKey:@"Station_Eng"] image:[[_stationArray objectAtIndex:i]objectForKey:@"Num"] ];
        
        [self.stationPoint addAnnotation:annotation];
        [_annotationArray addObject:annotation];
    }
    [self.stationPoint selectAnnotation:[[self annotationArray]objectAtIndex:_nearStationNum] animated:YES];//顯示最近站點infowindow
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self getDirections];
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
    StationInfoViewController *contorller = [self.storyboard instantiateViewControllerWithIdentifier:@"StationInfo"];
    contorller.staNum = (int)[self.annotationArray indexOfObject:view.annotation];
    [self.navigationController pushViewController:contorller animated:YES];
    
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
        
        
        if (_staNum == 8 || _staNum == 27) {
            _staNum = 999;
        }else if( _staNum < 24 && _staNum >= 0){
            _staNum = _staNum + 101;//KMRT Open Data 編號：紅線＝車站編號+101
        }else if(_staNum > 23 && _staNum < 38){
            _staNum = _staNum + 177; //KMRT Open Data 編號：橘線＝車站編號+177
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerInfo:) userInfo:nil repeats:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerInfo:) userInfo:nil repeats:YES];
    _fTime = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 135, 30)];//時間畫面呈現
    _sTime = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 135, 30)];
    _fTime.textColor = [UIColor darkGrayColor];
    _sTime.textColor = [UIColor darkGrayColor];
    [_fTime setFont:[UIFont systemFontOfSize:14]];
    [_sTime setFont:[UIFont systemFontOfSize:14]];
    
    [stationTime addSubview:_fTime];
    [stationTime addSubview:_sTime];
    
    if (_staNum == 999) {
        _tTime = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 135, 30)];
        _frTime = [[UILabel alloc]initWithFrame:CGRectMake(170, 30, 135, 30)];
        [_tTime setFont:[UIFont systemFontOfSize:14]];
        [_frTime setFont:[UIFont systemFontOfSize:14]];
        _tTime.textColor = [UIColor darkGrayColor];
        _frTime.textColor = [UIColor darkGrayColor];
        
        [stationTime addSubview:_tTime];
        [stationTime addSubview:_frTime];
        
        _fTime.frame = CGRectMake(70, 0, 135, 30);
        _sTime.frame = CGRectMake(170, 0, 135, 30);
        stationTime.frame = CGRectMake((self.view.frame.size.width/2)-150, -80, 300, 60);
        staImage.frame = CGRectMake(20, (stationTime.frame.size.height/2)-(staImage.frame.size.height/2), staImage.frame.size.width, staImage.frame.size.height);
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        stationTime.frame  = CGRectMake(stationTime.frame.origin.x, 80, stationTime.frame.size.width,stationTime.frame.size.height);
        
    } completion:^(BOOL finished){}];
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view viewWithTag:1].frame  = CGRectMake([self.view viewWithTag:1].frame.origin.x, -80, [self.view viewWithTag:1].frame.size.width,[self.view viewWithTag:1].frame.size.height);
    } completion:^(BOOL finished){
        [[self.view viewWithTag:1] removeFromSuperview];
    }];
}

- (void) getDirections{
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *placeMark = [[MKPlacemark alloc]initWithCoordinate:stationLocation addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placeMark];
    request.destination = mapItem;
    
    request.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
        if(error){
            NSLog(@"%@",[error description]);
        }else{
            [self showRoute:response];
        }
    }];
}

- (void) showRoute:(MKDirectionsResponse *)response{
    //導引路線
    for (id<MKOverlay> overlayToRemove in self.stationPoint.overlays){
        if ([overlayToRemove isKindOfClass:[MKPolyline class]]){
            [_stationPoint removeOverlay:overlayToRemove];
        }
    }

    for (MKRoute *route in response.routes) {
        [_stationPoint addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        /*for (MKRouteStep *step in route.steps) {
            NSLog(@"%@",step.instructions);//導航文字；註解
        }*/
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];//設定導引線條樣式
    renderer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5];
    renderer.lineWidth = 5.0;
    return renderer;
    
}

-(void)timerInfo:(NSTimer *)sender{
    NSMutableArray *minute;//到站時間
    minute = [_app.lc getTimeArrival:_staNum];
    
    if (minute == NULL) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"無法取得資料" message:@"伺服器維護中，請使用其他功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];

        [_timer invalidate];
    }else{
    
        if (![[[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"arrival"]isEqualToString:@"e"]) {
            _fTime.text = [NSString stringWithFormat:@"往 %@：%@ 分",[[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"descr"],[[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"arrival"]];
        }else{
            _fTime.text = [NSString stringWithFormat:@"往 %@：End",[[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"descr"]];
        }
    
        if (![[[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"arrival"]isEqualToString:@"e"]) {
            _sTime.text = [NSString stringWithFormat:@"往 %@：%@ 分",[[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"descr"],[[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"arrival"]];
        }else{
            _sTime.text = [NSString stringWithFormat:@"往 %@：End",[[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"descr"]];
        }
        if (_staNum == 999) {//美麗島到站顯示
            if (![[[[minute objectAtIndex:0]objectAtIndex:3]objectForKey:@"arrival"]isEqualToString:@"e"]) {
                _tTime.text = [NSString stringWithFormat:@"往 %@：%@ 分",[[[minute objectAtIndex:0]objectAtIndex:3]objectForKey:@"descr"],[[[minute objectAtIndex:0]objectAtIndex:3]objectForKey:@"arrival"]];
            }else{
                _tTime.text = [NSString stringWithFormat:@"往 %@：End",[[[minute objectAtIndex:0]objectAtIndex:3]objectForKey:@"descr"]];
            }
            if (![[[[minute objectAtIndex:0]objectAtIndex:2]objectForKey:@"arrival"]isEqualToString:@"e"]) {
                _frTime.text = [NSString stringWithFormat:@"往 %@：%@ 分",[[[minute objectAtIndex:0]objectAtIndex:2]objectForKey:@"descr"],[[[minute objectAtIndex:0]objectAtIndex:2]objectForKey:@"arrival"]];
            }else{
                _frTime.text = [NSString stringWithFormat:@"往 %@：End",[[[minute objectAtIndex:0]objectAtIndex:2]objectForKey:@"descr"]];
            }
        }
    }

}

- (IBAction)locateMe:(id)sender{
    _stationPoint.showsUserLocation = YES;//定位按鈕
    _stationPoint.delegate = self;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(stationLocation, 800, 800);
    [self.stationPoint setRegion:viewRegion animated:YES];
    [_stationPoint setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];//切換畫面時timer終止
    NSLog(@"no");
    _timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![_timer isValid]) {
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timerInfo:) userInfo:nil repeats:NO];
        NSLog(@"gogo");
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerInfo:) userInfo:nil repeats:YES];
    }//切回頁面時啟動timer
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
