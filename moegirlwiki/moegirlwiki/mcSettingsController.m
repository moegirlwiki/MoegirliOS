//
//  mcSettingsController.m
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcSettingsController.h"

@interface mcSettingsController ()

@end

@implementation mcSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //[_SettingsTable reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark TableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //无图模式
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"无图模式";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = SwitchItem;
            
        } else if (indexPath.row == 1) {
            //SSL中转压缩
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"SSL中转压缩";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = SwitchItem;
            
            
        } else if (indexPath.row == 2) {
            //更新排版数据
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"更新排版数据";
            cell.detailTextLabel.text = @"最后检查日期：2014-10-24";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //清除缓存
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"清除本地缓存";
            cell.detailTextLabel.text = @"估计大小：";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    } else {
        if (indexPath.row == 0) {
            //意见反馈
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"反馈问题或建议";
            cell.detailTextLabel.text = @"帮助我们改进程序";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }else{
            //给我评分
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"给我评分";
            cell.detailTextLabel.text = @"据说给5星评价可以恢复程序猿的SAN值";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        
    }
        return cell;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"浏览设置";
    }else if (section == 1){
        return @"缓存";
    }else{
        return @"其它";
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"SSL中转压缩为实验性功能，可能不够稳定。\n\n定期升级排版数据可以提升浏览体验。\n\n\n";
    }else if (section == 1){
        return @"缓存清除后浏览页面将需要重新从服务器下载，使用缓存可以节省大量流量\n\n\n";
    }else{
        return @"\n\n\n© 2014 Moegirlsaikou Foundation.\nAll rights reserved.";
    }
}

#pragma mark goBackButton

- (IBAction)goBackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
