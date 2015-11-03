//
//  StationInfoViewController.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/2/18.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import "StationInfoViewController.h"
#import "StationInfoTableCell.h"
#import "StationInfoMap.h"

@implementation StationInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (_staSection==1) {
        _staNum = _staNum + 24;
    }
    NSMutableArray *staArray = _app.lc.getStation;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    
    _toiletArray = [[staArray objectAtIndex:_staNum]objectForKey:@"Toilet"];
    _elevatorArray = [[staArray objectAtIndex:_staNum]objectForKey:@"Elevator"];
    _bikeArray = [[staArray objectAtIndex:_staNum]objectForKey:@"Bicycle"];

    
    NSString *staCode = [[staArray objectAtIndex:_staNum]objectForKey:@"Num"];
    NSString *markString = [NSString stringWithFormat:@"station_%@",staCode];
    NSString *infoString = [NSString stringWithFormat:@"sta-info-%@",staCode];
    if ([staCode isEqualToString:@"O5"] || [staCode isEqualToString:@"R10"]) {
        _staImgView.image = [UIImage imageNamed:@"station_R10O5"];
        _staInfoImgView.image = [UIImage imageNamed:@"sta-info-R10O5"];
    }else{
        _staImgView.image = [UIImage imageNamed:markString];
        _staInfoImgView.image = [UIImage imageNamed:infoString];
    }
    _staNameLabel.text = [[staArray objectAtIndex:_staNum]objectForKey:@"Station"];
    _staNameEngLabel.text =  [[staArray objectAtIndex:_staNum]objectForKey:@"Station_Eng"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_staNum) {
        case 1:
        case 8:
        case 9:
        case 14:
        case 22:
        case 24:
        case 27:
            return 5;
        break;
        default:
            return 4;
        break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    StationInfoTableCell *cell = (StationInfoTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    switch (indexPath.row) {
        case 0:
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            switch (_staNum) {
                case 1:
                    cell.bulletinImgView.image = [UIImage imageNamed:@"airport"];
                    cell.valueLabel.text = @"國內線（出口2）、國際線（出口6）";
                    break;
                case 8:
                case 27:
                    cell.bulletinImgView.image = [UIImage imageNamed:@"sta-map-R10O5"];
                    cell.valueLabel.text = @"紅線/橘線轉乘";
                    break;
                case 9:
                case 22:
                    cell.bulletinImgView.image = [UIImage imageNamed:@"train"];
                    cell.valueLabel.text = @"台鐵轉乘";
                    break;
                case 14:
                    cell.bulletinImgView.image = [UIImage imageNamed:@"train"];
                    cell.valueLabel.text = @"高鐵/台鐵轉乘";
                    break;
                case 24:
                    cell.bulletinImgView.image = [UIImage imageNamed:@"boat"];
                    cell.valueLabel.text = @"鼓山渡輪站";
                    break;
                default:
                    cell.bulletinImgView.image = [UIImage imageNamed:@"toilet"];
                    cell.valueLabel.text = [NSString stringWithFormat:@"%@",[_toiletArray objectAtIndex:0]];
                    break;
            }
            break;
        case 1:
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (_staNum != 1 && _staNum != 8 && _staNum != 27 && _staNum != 22 && _staNum != 9 && _staNum != 14 && _staNum != 24) {
                cell.bulletinImgView.image = [UIImage imageNamed:@"elevator"];
                cell.valueLabel.text = [_elevatorArray objectAtIndex:0];
            }else{
                cell.bulletinImgView.image = [UIImage imageNamed:@"toilet"];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",[_toiletArray objectAtIndex:0]];
            }
            break;
        case 2:
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (_staNum != 1 && _staNum != 8 && _staNum != 27 && _staNum != 22 && _staNum != 9 && _staNum != 14 && _staNum != 24) {
                cell.bulletinImgView.image = [UIImage imageNamed:@"bike"];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",[_elevatorArray objectAtIndex:0]];
            }else{
                cell.bulletinImgView.image = [UIImage imageNamed:@"elevator"];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",[_elevatorArray objectAtIndex:0]];
            }
            break;
        case 3:
            if (_staNum != 1 && _staNum != 8 && _staNum != 27 && _staNum != 22 && _staNum != 9 && _staNum != 14 && _staNum != 24) {
                cell.bulletinImgView.image = [UIImage imageNamed:@"stainfomap"];
                cell.valueLabel.text = @"前往地圖";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.bulletinImgView.image = [UIImage imageNamed:@"bike"];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",[_elevatorArray objectAtIndex:0]];
            }
            break;
        case 4:
            cell.bulletinImgView.image = [UIImage imageNamed:@"stainfomap"];
            cell.valueLabel.text = @"前往地圖";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_staNum != 1 && _staNum != 8 && _staNum != 27 && _staNum != 22 && _staNum != 9 && _staNum != 14 && _staNum != 24) {
        if (indexPath.row == 3) {
            StationInfoMap *map = [self.storyboard instantiateViewControllerWithIdentifier:@"StaInfoMap"];
            map.selectNum = _staNum;
            [self.navigationController pushViewController:map animated:YES];
        }

    }else{
        if (indexPath.row == 4) {
            StationInfoMap *map = [self.storyboard instantiateViewControllerWithIdentifier:@"StaInfoMap"];
            map.selectNum = _staNum;
            [self.navigationController pushViewController:map animated:YES];
        }

    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


@end
