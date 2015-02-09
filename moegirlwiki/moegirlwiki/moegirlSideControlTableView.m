//
//  moegirlSideControlTableView.m
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlSideControlTableView.h"

@implementation moegirlSideControlTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 首页
 刷新
 分享
 收藏
 －
 收藏夹
 －
 设置
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"萌娘百科iOS客户端";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.detailTextLabel.text = @"v2.5";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.878 green:0.98 blue:0.851 alpha:1];
    } else if (indexPath.row == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"首页";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if (indexPath.row == 3) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"刷新";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if (indexPath.row == 4) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"编辑本页";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if (indexPath.row == 5) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.row == 6) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"设置";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if (indexPath.row == 7) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"关于";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        //mainpage
        [self.hook ctrlPanelCallMainpage];
    } else if (indexPath.row == 3) {
        //refresh
        [self.hook ctrlPanelCallRefresh];
    } else if (indexPath.row == 4) {
        //refresh
        [self.hook ctrlPanelCallEditor];
    } else if (indexPath.row == 6) {
        //Settings
        [self.hook ctrlPanelCallSettings];
    } else if (indexPath.row == 7) {
        //About
        [self.hook ctrlPanelCallAbout];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        return 20;
    } else if (indexPath.row == 1) {
        return 44;
    } else if (indexPath.row == 2) {
        return 40;
    } else if (indexPath.row == 3) {
        return 40;
    } else if (indexPath.row == 4) {
        return 40;
    } else if (indexPath.row == 5) {
        return self.frame.size.height - 275;
    } else if (indexPath.row == 6) {
        return 40;
    } else {
        return 40;
    }
}


@end
