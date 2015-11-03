//
//  StationViewController.m
//  KMRT
//
//  Created by Yang Tun-Kai on 2014/1/20.
//  Copyright (c) 2014年 Yang Tun-Kai. All rights reserved.
//

#import "StationViewController.h"

@implementation StationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    switch (section) {
        case 0:
            rowCount = 24;
            break;
        case 1:
            rowCount = 14;
            break;
        default:
            break;
    }
    return rowCount;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *title;
    switch (section) {
        case 0:
            title = @"紅線";
            break;
        case 1:
            title = @"橘線";
            break;
        default:
            break;
    }
    return title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *stationArray = [_app.lc getStation];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger row = indexPath.row;
    NSString *imageName;
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[stationArray objectAtIndex:row]objectForKey:@"Station"];
            cell.detailTextLabel.text = [[stationArray objectAtIndex:row]objectForKey:@"Station_Eng"];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            imageName = [@"sta-" stringByAppendingString:[[stationArray objectAtIndex:row]objectForKey:@"Num"]];
            cell.imageView.image = [UIImage imageNamed:imageName];
        
            break;
        case 1:
            row = row + 24;//橘線起始編號
            cell.textLabel.text = [[stationArray objectAtIndex:row]objectForKey:@"Station"];
            cell.detailTextLabel.text = [[stationArray objectAtIndex:row]objectForKey:@"Station_Eng"];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            imageName = [@"sta-" stringByAppendingString:[[stationArray objectAtIndex:row]objectForKey:@"Num"]];
            cell.imageView.image = [UIImage imageNamed:imageName];

            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        
        switch (section) {
            case 0:
                tableViewHeaderFooterView.textLabel.textColor = [UIColor whiteColor];
                tableViewHeaderFooterView.contentView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:68.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
                break;
            case 1:
                tableViewHeaderFooterView.textLabel.textColor = [UIColor whiteColor];
                tableViewHeaderFooterView.contentView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:171.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                break;
            default:
                break;
        }
    }
    tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StationInfoViewController *staInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"StationInfo"];
    staInfo.staNum = (int)indexPath.row;
    staInfo.staSection = (int)indexPath.section;
    [self.navigationController pushViewController:staInfo animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
