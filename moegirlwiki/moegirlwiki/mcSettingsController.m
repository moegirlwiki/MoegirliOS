//
//  mcSettingsController.m
//  moegirlwiki
//
//  Created by Michael Chan on 14-8-29.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcSettingsController.h"

@interface mcSettingsController ()
- (IBAction)GoBackButton:(id)sender;

@end

@implementation mcSettingsController

@synthesize rtitle;
@synthesize rcontent;
@synthesize rerror;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)GoBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Table View 构建代码======================开始
============================================================*/

// tableView 每个不同Group的项目数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else{
        return 3;
    }
}

// tableView 中Group的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// tableView Section Header的值
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"浏览设置";
    }else if (section == 1){
        return @"界面自定义";
    }else{
        return @"其它";
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"请在网络环境良好的地方更新页面排版数据。页面排版数据不会经常更新。\n\n";
    }else if (section == 1){
        return @"建议使用电脑将图片裁剪为200x200的图片，保存为带透明背景的PNG格式，然后保存到手机相册中。\n\n\n";
    }else{
        return @"\n\n© 2014 Moegirlsaikou Foundation.\nAll rights reserved.";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"无图模式";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            if ([[defaultdata objectForKey:@"NoImgMode"]isEqualToString:@"ON"]) {
                SwitchItem.on = YES;
            } else {
                SwitchItem.on = NO;
            }
            
            [SwitchItem addTarget:self action:@selector(NoImageMode_Switch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = SwitchItem;
            
        }else if (indexPath.row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"左右拉动翻页";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            if ([[defaultdata objectForKey:@"SwipeMode"]isEqualToString:@"ON"]) {
                SwitchItem.on = YES;
            } else {
                SwitchItem.on = NO;
            }
            
            [SwitchItem addTarget:self action:@selector(SwipeSwitchMode_Switch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = SwitchItem;
            
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"更新页面排版数据";
            cell.detailTextLabel.text = @"当前版本 2014-09-05";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"设置菜单图片";
            cell.detailTextLabel.text = @"推荐使用75x75以上背景透明的图片";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"还原菜单图片";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"检测服务器可用性";
            cell.detailTextLabel.text = @"若遇不明错误，可以使用此诊断";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"给我评分";
            cell.detailTextLabel.text = @"据说五星好评可以给程序猿们恢复SAN值";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"更新说明";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

-(void)NoImageMode_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    
    if ([switchView isOn])  {
        NSLog(@"ON  -- 无图模式");
        [defaultdata setObject:@"ON" forKey:@"NoImgMode"];
        [defaultdata synchronize];
    } else {
        NSLog(@"OFF -- 无图模式");
        [defaultdata setObject:@"OFF" forKey:@"NoImgMode"];
        [defaultdata synchronize];
    }
}

-(void)SwipeSwitchMode_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    
    if ([switchView isOn])  {
        NSLog(@"ON  -- 左右滑动翻页");
        [defaultdata setObject:@"ON" forKey:@"SwipeMode"];
        [defaultdata synchronize];
    } else {
        NSLog(@"OFF -- 左右滑动翻页");
        [defaultdata setObject:@"OFF" forKey:@"SwipeMode"];
        [defaultdata synchronize];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"无图模式 点击");
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"左右拉动翻页 点击");
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        NSLog(@"更新页面排版数据 点击");
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"设置菜单图片 点击");
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        NSLog(@"还原菜单图片 点击");
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        NSLog(@"检测服务器可用性 点击");
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



/* Table View 构建代码=========================结束
 ============================================================*/

@end
