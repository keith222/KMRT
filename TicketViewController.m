//
//  TicketViewController.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/20.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

//概念：設一個table cell view 在下面 然後 左邊畫圖 右邊顯示;時間、票價文字重新用

#import "TicketViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@implementation TicketViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self.contentScroll setScrollEnabled:YES];
    self.contentScroll.contentSize = CGSizeMake(self.contentScroll.frame.size.width, 500);
    
    //設定車站選擇按鈕
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(61, 0, 230, 40)];
    startBtn.tag = 1;
    startBtn.layer.borderWidth = 0.5;
    startBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UIButton *endBtn = [[UIButton alloc]initWithFrame:CGRectMake(61, 0, 230, 40)];
    endBtn.tag = 2;
    endBtn.layer.borderWidth = 0.5;
    endBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [startBtn addTarget:self action:@selector(pickerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [endBtn addTarget:self action:@selector(pickerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //設定乘車時間+票價Label
    _tickeTime.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tickeTime.layer.borderWidth = 0.4;
    
    //設定選擇起迄站的UIView
    UIView *startEnd = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 170)];
    startEnd.layer.borderColor = [UIColor lightGrayColor].CGColor;
    startEnd.layer.borderWidth = 0.4;

    //設定起迄站UIView裡的UILabel
    UILabel *seTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    seTitle.backgroundColor = [UIColor lightGrayColor];
    seTitle.text = @"起迄站選擇";
    seTitle.textAlignment = NSTextAlignmentCenter;
    seTitle.textColor = [UIColor whiteColor];
    seTitle.font = [UIFont boldSystemFontOfSize:20];
    
    //設定起迄站UIView裡的起站與迄站View及Content
    UIView *startStation = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 315, 60)];
    UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, 40)];
    start.text = @"起站：";
    start.font = [UIFont systemFontOfSize:20];
    start.textColor = [UIColor lightGrayColor];
    UIView *endStataion = [[UIView alloc]initWithFrame:CGRectMake(0, 111, 315, 60)];
    UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, 40)];
    end.text = @"迄站：";
    end.font = [UIFont systemFontOfSize:20];
    end.textColor = [UIColor lightGrayColor];
    
    
    //從LocationController抓車站資料
    _stationList = [_app.lc getStation];
    
    //將以上設定顯示在畫面上
    [self.contentScroll addSubview:startEnd];
    [startEnd addSubview:seTitle];
    [startEnd addSubview:startStation];
    [startEnd addSubview:endStataion];
    [startStation addSubview:start];
    [startStation addSubview:startBtn];
    [endStataion addSubview:end];
    [endStataion addSubview:endBtn];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _stationList.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *stationPick = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 33)];
    if (row > 23) {
        stationPick.backgroundColor = [UIColor orangeColor];
    }else{
        stationPick.backgroundColor = [UIColor colorWithRed:194.0f/255.0f green:42.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    }

    stationPick.textColor = [UIColor whiteColor];
    stationPick.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    stationPick.text = [[_stationList objectAtIndex:row]objectForKey:@"Station"];
    stationPick.textAlignment = NSTextAlignmentCenter;
    return stationPick;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray *stationTime;
    NSString *startName, *endName, *tripTime;
    LocationController *time = [[LocationController alloc]init];
    stationTime = [time getStationTime];
    UIButton *startBtn = (UIButton *)[self.view viewWithTag:1];
    UIButton *endBtn = (UIButton *)[self.view viewWithTag:2];
 
    switch (_btnTag) {
        case 1:
            _nowStaNumf = (int)row;
            startName = [[self.stationList objectAtIndex:row]objectForKey:@"Station"];
            startBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            [startBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [startBtn setTitle:startName forState:UIControlStateNormal];
            [startBtn resignFirstResponder];
            endName = endBtn.titleLabel.text;
            if (endName != NULL) {
                if ([startName isEqualToString:endName]) {
                    tripTime = @"0";
                }else{
                    tripTime = [[[stationTime objectAtIndex:0]objectForKey:startName]objectForKey:endName];
                }
                [self startLocation:startName endLocation:endName];
                _timeLabel.text = [NSString stringWithFormat:@"%@",tripTime];
            }
            break;
        case 2:
            _nowStaNumt = (int)row;
            endName = [[self.stationList objectAtIndex:row]objectForKey:@"Station"];
            endBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            [endBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [endBtn setTitle:endName forState:UIControlStateNormal];
            startName = startBtn.titleLabel.text;
            [endBtn resignFirstResponder];
            if (startName != NULL) {
                if ([startName isEqualToString:endName]) {
                    tripTime = @"0";
                }else{
                    tripTime = [[[stationTime objectAtIndex:0]objectForKey:startName]objectForKey:endName];
                }
                [self startLocation:startName endLocation:endName];
                _timeLabel.text = [NSString stringWithFormat:@"%@",tripTime];
            }
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^(void){pickerView.frame = CGRectMake(0, (self.view.bounds.size.height+1), 320, 216);}completion:^(BOOL finished) {[pickerView removeFromSuperview];}];
}


-(void)startLocation:(NSString *)start endLocation:(NSString *)end{
    int ticketPrice;
    CLLocation *startPoint, *endPoint, *middlePoint;
    NSString *sLine, *eLine;
    for (int i=0; i<[_stationList count]; i++) {
        if ([[[_stationList objectAtIndex:i]objectForKey:@"Station"] isEqualToString:start]) {
            startPoint = [[CLLocation alloc]initWithLatitude: [[[_stationList objectAtIndex:i]objectForKey:@"Latitude"]floatValue] longitude:[[[_stationList objectAtIndex:i]objectForKey:@"Longitude"]floatValue]];
            sLine = [[_stationList objectAtIndex:i]objectForKey:@"Line"];
        }else if([[[_stationList objectAtIndex:i]objectForKey:@"Station"] isEqualToString:end]){
            endPoint = [[CLLocation alloc]initWithLatitude: [[[_stationList objectAtIndex:i]objectForKey:@"Latitude"]floatValue] longitude:[[[_stationList objectAtIndex:i]objectForKey:@"Longitude"]floatValue]];
            eLine = [[_stationList objectAtIndex:i]objectForKey:@"Line"];
        }
    }
    
    if(_nowStaNumf == 8){
        sLine = @"Red";
    }else if(_nowStaNumf == 27){
        sLine = @"Orange";
    }else if(_nowStaNumt == 27){
        eLine = @"Orange";
    }else if(_nowStaNumt == 8){
        eLine = @"Red";
    }
    
    if ([start isEqualToString:end]) {
        endPoint = startPoint;
        eLine = sLine;
    }
    
    CLLocationDistance distance = 0.0;
    if ([sLine isEqualToString:eLine]) {
        distance =[startPoint distanceFromLocation:endPoint]/1000;
        _countNum = 3;
    }else{
        middlePoint = [[CLLocation alloc]initWithLatitude:[[[_stationList objectAtIndex:8]objectForKey:@"Latitude"]floatValue]longitude:[[[_stationList objectAtIndex:8]objectForKey:@"Longitude"]floatValue]];
        distance = ([startPoint distanceFromLocation:middlePoint]/1000) + ([middlePoint distanceFromLocation:endPoint]/1000);
        _countNum = 5;
    }

    if (distance < 5) {
        ticketPrice = 20;
    }else if (distance >=5 && distance < 7){
        ticketPrice = 25;
    }else if (distance >= 7 && distance < 9){
        ticketPrice = 30;
    }else if (distance >= 9 && distance < 11){
        ticketPrice = 35;
    }else if (distance >= 11 && distance < 13){
        ticketPrice = 40;
    }else if (distance >= 13 && distance < 15){
        ticketPrice = 45;
    }else if (distance >= 15 && distance < 17){
        ticketPrice = 50;
    }else if (distance >= 17 && distance < 20){
        ticketPrice = 55;
    }else {
        ticketPrice = 60;
    }
    
    [self getTripProcess];
    _priceLabel.text = [NSString stringWithFormat:@"%d",ticketPrice];
    
}

- (void)getTripProcess{
    
    NSString *imgName;
    NSString *staNumf, *staNumt;
    [_tripProcess removeFromSuperview];
    if(![_tripProcess isDescendantOfView:self.contentScroll]){
        _tripProcess= [[UIView alloc]initWithFrame:CGRectMake(10, 270, 300, 0)];
        CGRect frame = _tripProcess.frame;
        if (_countNum == 3) {
            frame.size.width = 300;
            frame.size.height = 132;
            _tripProcess.frame = frame;
        }else if(_countNum == 5){
            frame.size.width = 300;
            frame.size.height = 220;
            _tripProcess.frame = frame;
        }
        
        staNumf = [[_stationList objectAtIndex:_nowStaNumf]objectForKey:@"Num"];
        staNumt = [[_stationList objectAtIndex:_nowStaNumt]objectForKey:@"Num"];
        if ([staNumf isEqualToString:@"R10"]||[staNumf isEqualToString:@"O5"]) {
            staNumf = @"R10O5";
        }
        if ([staNumt isEqualToString:@"R10"]||[staNumt isEqualToString:@"O5"]) {
            staNumt = @"R10O5";
        }
        
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 41, 4, 50)];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 129, 4, 50)];
        UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88, 44, 44)];
        UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 176, 44, 44)];
        
        UILabel *staTripProcess1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 250, 44)];
        staTripProcess1.textColor = [UIColor grayColor];
        staTripProcess1.font = [UIFont systemFontOfSize:20];
        UILabel *staTripProcess2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 88, 250, 44)];
        staTripProcess2.textColor = [UIColor grayColor];
        staTripProcess2.font = [UIFont systemFontOfSize:20];
        UILabel *staTripProcess3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 176, 250, 44)];
        staTripProcess3.textColor = [UIColor grayColor];
        staTripProcess3.font = [UIFont systemFontOfSize:20];
        
        CALayer *bottomBorder1 = [CALayer layer];
        bottomBorder1.frame = CGRectMake(0,40, 240, 0.4);
        bottomBorder1.backgroundColor = [UIColor lightGrayColor].CGColor;
        CALayer *bottomBorder2 = [CALayer layer];
        bottomBorder2.frame = CGRectMake(0,40, 240, 0.4);
        bottomBorder2.backgroundColor = [UIColor lightGrayColor].CGColor;
        CALayer *bottomBorder3 = [CALayer layer];
        bottomBorder3.frame = CGRectMake(0,40, 240, 0.4);
        bottomBorder3.backgroundColor = [UIColor lightGrayColor].CGColor;
        
        for (int i=1 ; i<=_countNum; i++) {
            switch (i) {
                case 1:
                    imgName = [@"sta-map-" stringByAppendingString:staNumf];
                    imageView1.image = [UIImage imageNamed:imgName];
                    staTripProcess1.text = [[_stationList objectAtIndex:_nowStaNumf]objectForKey:@"Station"];
                    [_tripProcess addSubview:imageView1];
                    [_tripProcess addSubview:staTripProcess1];
                    [staTripProcess1.layer addSublayer:bottomBorder1];
                    break;
                case 2:
                    if ((_nowStaNumf<24 && _nowStaNumf != 8)|| _nowStaNumf == 8) {
                            imageView2.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:68.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
                        [_tripProcess addSubview:imageView2];
                    }else if ((_nowStaNumf > 24 && _nowStaNumf != 8) || _nowStaNumf == 8){
                        imageView2.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:171.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                        [_tripProcess addSubview:imageView2];
                    }
                    
                    break;
                case 3:
                    if (_countNum == 3) {
                        imgName = [@"sta-map-" stringByAppendingString:staNumt];
                        imageView3.image = [UIImage imageNamed:imgName];
                        staTripProcess2.text = [[_stationList objectAtIndex:_nowStaNumt]objectForKey:@"Station"];
                        [_tripProcess addSubview:imageView3];
                        [_tripProcess addSubview:staTripProcess2];
                        [staTripProcess2.layer addSublayer:bottomBorder2];
                    }else if (_countNum == 5){
                        imageView3.image = [UIImage imageNamed:@"sta-map-R10O5"];
                        staTripProcess2.text = @"美麗島（步行轉乘）";
                        staTripProcess2.textColor = [UIColor lightGrayColor];
                        [_tripProcess addSubview:imageView3];
                        [_tripProcess addSubview:staTripProcess2];
                        [staTripProcess2.layer addSublayer:bottomBorder2];
                    }
                    break;
                case 4:
                    if (_nowStaNumt<24 && _nowStaNumt != 8) {
                        imageView4.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:68.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
                        [_tripProcess addSubview:imageView4];
                    }else if (_nowStaNumt >= 24 && _nowStaNumt != 8 ){
                        imageView4.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:171.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                        [_tripProcess addSubview:imageView4];
                    }

                    break;
                case 5:
                    imgName = [@"sta-map-" stringByAppendingString:staNumt];
                    imageView5.image = [UIImage imageNamed:imgName];
                    staTripProcess3.text = [[_stationList objectAtIndex:_nowStaNumt]objectForKey:@"Station"];
                    [_tripProcess addSubview:imageView5];
                    [_tripProcess addSubview:staTripProcess3];
                    [staTripProcess3.layer addSublayer:bottomBorder3];
                    break;
                default:
                    break;
            }
            
        }
    }
    [self.contentScroll addSubview:_tripProcess];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerBtnPressed:(UIButton *)sender{
    //找出目前的row
    int row = 0;
    if (sender.tag == 1) {
        row = _nowStaNumf;
    }else{
        row = _nowStaNumt;
    }
    [self showPickerAtRow:row fromRect:sender.frame tag:(int)sender.tag];
}

- (void)showPickerAtRow:(int)row fromRect:(CGRect)rect tag:(int)tag{
    //移除重複存在的UIPickerView
    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[UIPickerView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    //按鈕編號
    _btnTag = tag;
    
    //建立picker
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height+1), 320, 216)];
    [pickerView removeFromSuperview];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    [UIView animateWithDuration:0.5 animations:^(void){pickerView.frame = CGRectMake(0, (self.view.bounds.size.height-250), 320, 216);}];
    
    //自動捲到目前的row
    [pickerView selectRow:row inComponent:0 animated:YES];
    
}

@end
