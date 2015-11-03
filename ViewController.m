//
//  ViewController.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/19.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@implementation ViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    languages = [NSLocale preferredLanguages];
    currentLanguage = [languages objectAtIndex:0];
    
    [_directNW setAlpha:0];
    [_directSE setAlpha:0];
    [_ForDirE setAlpha:0];
    [_ForDirW setAlpha:0];
    [_staName setAlpha:0];
    [_staEngName setAlpha:0];
    [_staMarkView setAlpha:0];
    
    [self.contentScroll setScrollEnabled:YES];
    //self.contentScroll.contentSize = CGSizeMake(self.contentScroll.frame.size.width, 360);
    
    CALayer *layerNW = [_directNW layer];
    CALayer *bottomBorderNW = [CALayer layer];
    bottomBorderNW.borderWidth = 1;
    bottomBorderNW.frame = CGRectMake(0, (layerNW.frame.size.height)-15, layerNW.frame.size.width, 1);
    [bottomBorderNW setBorderColor:[UIColor lightGrayColor].CGColor];
    [layerNW addSublayer:bottomBorderNW];
    
    CALayer *layerSE = [_directSE layer];
    CALayer *bottomBorderSE = [CALayer layer];
    bottomBorderSE.borderWidth = 1;
    bottomBorderSE.frame = CGRectMake(0, (layerSE.frame.size.height)-15, layerSE.frame.size.width, 1);
    [bottomBorderSE setBorderColor:[UIColor lightGrayColor].CGColor];
    [layerSE addSublayer:bottomBorderSE];
    
    CALayer *layerForW = [_ForDirW layer];
    CALayer *bottomBorderW = [CALayer layer];
    bottomBorderW.borderWidth = 1;
    bottomBorderW.frame = CGRectMake(0, (layerForW.frame.size.height)-15, layerForW.frame.size.width, 1);
    [bottomBorderW setBorderColor:[UIColor lightGrayColor].CGColor];
    [layerForW addSublayer:bottomBorderW];
    
    CALayer *layerForE = [_ForDirE layer];
    CALayer *bottomBorderE = [CALayer layer];
    bottomBorderE.borderWidth = 1;
    bottomBorderE.frame = CGRectMake(0, (layerForE.frame.size.height)-15, layerForE.frame.size.width, 1);
    [bottomBorderE setBorderColor:[UIColor lightGrayColor].CGColor];
    [layerForE addSublayer:bottomBorderE];
    
    
    locationManager = [[CLLocationManager alloc]init];
    if (IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
    }//因應iOS8後針對地理資訊的要求

    HUD = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];//設定loading圖示
    HUD.labelText = @"Loading...";
    
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;//地理定位精準度為百公尺
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];//開始更新地理資訊
    
    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stationTime:) userInfo:nil repeats:YES];


}

-(void)stationTime:(NSTimer *)sender{
    NSMutableArray *minute;//到站時間
    NSLog(@"go");
 
    //設定畫面資訊呈現
    _toNW.text = @"往";
    _toSE.text = @"往";
    _toForE.text = @"往";
    _toForW.text = @"往";
    _minOne.text = @"分";
    _minTwo.text = @"分";
    _minForW.text = @"分";
    _minForE.text = @"分";
    
    if (num == 8 || num == 27) {
        num = 999;//KMRT Open Data 美麗島紅橘用編號
    }else if(num < 24 && num >= 0){
        num = num + 101;//KMRT Open Data 編號：紅線＝車站編號+101
    }else if(num > 23 && num < 38){
        num = num + 177; //KMRT Open Data 編號：橘線＝車站編號+177
    }
    minute = [app.lc getTimeArrival:num];//取得到站時間
    if (minute == NULL) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"無法取得資料" message:@"伺服器維護中，請使用其他功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [timer invalidate];
    }else{
        //以多國語系設定列車方向
        if ([[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] isEqualToString:@"en"]) {
            if ( num < 124 && num > 101 ) { _terminalNW.text = @"Gangshan S.";_terminalSE.text = @"Siaogang";}
            if ( num > 201 && num < 214) { _terminalNW.text = @"Sizihwan";_terminalSE.text = @"Daliao";}
            if ( num == 101){ _terminalNW.text = @"Gangshan S.";_terminalSE.text = @"Gangshan S.";}
            if ( num == 124){ _terminalNW.text = @"Siaogang";_terminalSE.text = @"Siaogang";}
            if ( num == 201){ _terminalNW.text = @"Daliao";_terminalSE.text = @"Daliao";}
            if ( num == 214){ _terminalNW.text = @"Sizihwan";_terminalSE.text = @"Sizihwan";}
            if ( num == 999){ _terminalNW.text = @"Gangshan S.";_terminalSE.text = @"Siaogang";_terminalForW.text = @"Sizihwan";_terminalForE.text = @"Daliao";}
        }else{
            if ( num < 124 && num > 101 ) { _terminalNW.text = @"南岡山";_terminalSE.text = @"小港";}
            if ( num > 201 && num < 214) { _terminalNW.text = @"西子灣";_terminalSE.text = @"大寮";}
            if ( num == 101){ _terminalNW.text = @"南岡山";_terminalSE.text = @"南岡山";}
            if ( num == 124){ _terminalNW.text = @"小港";_terminalSE.text = @"小港";}
            if ( num == 201){ _terminalNW.text = @"大寮";_terminalSE.text = @"大寮";}
            if ( num == 214){ _terminalNW.text = @"西子灣";_terminalSE.text = @"西子灣";}
            if ( num == 999){_terminalNW.text = @"南岡山";_terminalSE.text = @"小港";_terminalForW.text = @"西子灣";_terminalForE.text = @"大寮";}
        }
        
        if (![[[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"arrival"]isEqualToString:@"e"]) {
            _minNW.text = [[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"arrival"];
        }else{
            _minNW.text = @"";
            _minOne.text = @"End";
        }
        if (![[[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"arrival"]isEqualToString:@"e"]) {
           _minSE.text = [[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"arrival"];
        }else{
            _minSE.text = @"";
            _minTwo.text = @"End";
        }
        if ( num == 999 ) {//美麗島到站顯示
            self.contentScroll.contentSize = CGSizeMake(self.contentScroll.frame.size.width, 475);
            [_ForDirW setHidden:NO];
            [_ForDirE setHidden:NO];
            if (![[[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"arrival"]isEqualToString:@"e"]) {
                _minNW.text = [[[minute objectAtIndex:0]objectAtIndex:0]objectForKey:@"arrival"];
            }else{
                _minNW.text = @"";
                _minOne.text = @"End";
            }
            if (![[[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"arrival"]isEqualToString:@"e"]) {
                _minSE.text = [[[minute objectAtIndex:0]objectAtIndex:1]objectForKey:@"arrival"];
            }else{
                _minNW.text = @"";
                _minTwo.text = @"End";
            }
            if (![[[[minute objectAtIndex:0]objectAtIndex:2]objectForKey:@"arrival"]isEqualToString:@"e"]) {
                _minsForW.text = [[[minute objectAtIndex:0]objectAtIndex:2]objectForKey:@"arrival"];
            }else{
                _minsForW.text = @"";
                _minForW.text = @"End";
            }
            if (![[[[minute objectAtIndex:0]objectAtIndex:3]objectForKey:@"arrival"]isEqualToString:@"e"]) {
                _minsForE.text = [[[minute objectAtIndex:0]objectAtIndex:3]objectForKey:@"arrival"];
            }else{
                _minsForE.text = @"";
                _minForE.text = @"End";
            }
        }else{
            self.contentScroll.contentSize = CGSizeMake(self.contentScroll.frame.size.width, 380);
            [_ForDirE setHidden:YES];
            [_ForDirW setHidden:YES];
        }

    }
    [HUD hide:YES];
    [self fadeIn];


}

-(void)fadeIn{
    [UIView animateWithDuration:1.0f animations:^{
        [_directNW setAlpha:1];
        [_directSE setAlpha:1];
        [_staName setAlpha:1];
        [_staEngName setAlpha:1];
        [_staMarkView setAlpha:1];
        if (num == 999) {
            [_ForDirE setAlpha:1];
            [_ForDirW setAlpha:1];
        }
        
    } completion:nil];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //[locationManager stopUpdatingLocation];

    tempLocation = newLocation;
    CLLocationDistance distanceBetween;//兩點間距離
    NSString *stationName, *stationEngName, *staCode;//車站名稱、車站英文名稱、車站編號
    NSMutableArray *staNum = app.lc.getStation;//車站編號陣列
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
    NSDictionary *dict;
    NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[staNum count]; i++) {//計算離使用者最近的車站
    
        CLLocation *staLocation = [[CLLocation alloc]initWithLatitude:[[[staNum objectAtIndex:i] objectForKey:@"Latitude"] floatValue ] longitude:[[[staNum objectAtIndex:i] objectForKey:@"Longitude"] floatValue ]];
        
        distanceBetween = [tempLocation distanceFromLocation:staLocation];
        
        [mDict setObject:[NSNumber numberWithFloat:distanceBetween] forKey:[NSNumber numberWithInt:i]];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"staNum",[NSNumber numberWithFloat:distanceBetween],@"distance", nil];
        [distanceArray addObject:dict];
        
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    [distanceArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];//距離排序
    
    num = [[[distanceArray objectAtIndex:0]objectForKey:@"staNum"]intValue];
    
    if (num != app.globalStaNum) {
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(stationTime:) userInfo:nil repeats:NO];
    }
    
    stationName = [[staNum objectAtIndex:num]objectForKey:@"Station"];
    stationEngName = [[staNum objectAtIndex:num]objectForKey:@"Station_Eng"];
    staCode = [[staNum objectAtIndex:num]objectForKey:@"Num"];
    
    app.globalStaNum = num; //將車站編號存入全域變數globalStaNum
    

    //畫面顯示車站名稱及站標
    _staName.text = stationName;
    _staEngName.text = stationEngName;
    NSString *markString = [NSString stringWithFormat:@"station_%@",staCode];
    if ([staCode isEqualToString:@"O5"] || [staCode isEqualToString:@"R10"]) {//美麗島站狀況
        _staMarkView.image = [UIImage imageNamed:@"station_R10O5"];
        [self.contentScroll addSubview:_staMarkView];
    }else{
        _staMarkView.image = [UIImage imageNamed:markString];
        [self.contentScroll addSubview:_staMarkView];
               
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
    [timer invalidate];//切換畫面時timer終止
    timer = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![timer isValid]) {
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(stationTime:) userInfo:nil repeats:NO];
        timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stationTime:) userInfo:nil repeats:YES];
        [locationManager startUpdatingLocation];
    }//切回頁面時啟動timer
}

@end
