//
//  mcSettingsController.m
//  moegirlwiki
//
//  Created by Michael Chan on 14-8-29.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcSettingsController.h"

@interface mcSettingsController ()
@property (strong,nonatomic) NSMutableData *RecieveContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Loader;
@property (weak, nonatomic) IBOutlet UILabel *LabelMsg;
@property (weak, nonatomic) IBOutlet UITableView *MasterTableView;
- (IBAction)GoBackButton:(id)sender;

@end

@implementation mcSettingsController

@synthesize rtitle;
@synthesize rcontent;
@synthesize rerror;

NSURLConnection * RequestConnectionForCus;


NSString * APICustomize = @"https://masterchan.me/moegirlwiki/customize1.5.txt";//获取自定义样式的
NSString * AppStoreURL = @"itms-apps://itunes.apple.com/app/id892053828";
NSString * UpdateInfo = @"▪️首页及大部分排版数据是缓存在手机中的，如果需要查看最新内容，请点击菜单中的刷新按钮；\n\n\
▪️通过 报告问题页面 提交任何使用过程中遇到的困难或错误，可以帮助我们改进此程序；\n\n\
▪️被涂黑的内容 点击即可查看；\n\n\
▪️这个程序目前基本上只是一个经过优化的浏览器壳子，目的是为大家提供iOS上最佳的访问萌百的体验，其它功能请自行探索😬\n\n";

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
        return 4;
    }else if (section == 1){
        return 2;
    }else{
        return 2;
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
        return @"请在网络环境良好的地方更新页面排版数据。该功能为实验性功能，页面排版数据无需经常更新。\n\n\n";
    }else if (section == 1){
        return @"建议使用电脑将图片裁剪为200x200，并保存为带透明背景的PNG格式，然后保存到手机相册中，再选取该图片作为菜单图标。\n\n\n";
    }else{
        return @"\n\n\n© 2014 Moegirlsaikou Foundation.\nAll rights reserved.";
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
            
        }else if (indexPath.row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"和谐模式";
            cell.detailTextLabel.text = @"看不到？一定是打开的方式不对！";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            if ([[defaultdata objectForKey:@"HeXieMode"]isEqualToString:@"ON"]) {
                SwitchItem.on = YES;
            } else {
                SwitchItem.on = NO;
            }
            
            [SwitchItem addTarget:self action:@selector(HeXieMode_Switch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = SwitchItem;
            
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            
            cell.textLabel.text = @"更新页面排版数据";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本 %@",[defaultdata objectForKey:@"CustomizeDate"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"自定义菜单图标";
            cell.detailTextLabel.text = @"推荐使用75x75以上背景透明的图片";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"还原菜单图标";
            cell.detailTextLabel.text = @"更新姬大法好，萌娘保平安";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"给我评分";
            cell.detailTextLabel.text = @"据说五星好评可以给程序猿们恢复SAN值";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.textLabel.text = @"功能说明";
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

-(void)HeXieMode_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    
    if ([switchView isOn])  {
        NSLog(@"ON  -- 和谐模式");
        [defaultdata setObject:@"ON" forKey:@"HeXieMode"];
        [defaultdata synchronize];
    } else {
        NSLog(@"OFF -- 和谐模式");
        [defaultdata setObject:@"OFF" forKey:@"HeXieMode"];
        [defaultdata synchronize];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"无图模式 点击");
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"左右拉动翻页 点击");
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        NSLog(@"和谐模式 点击");
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        NSLog(@"更新页面排版数据 点击");
        /*
         1. 询问是否更新（确认、取消）
         2. 界面封锁
         3. 更新成功｜更新失败
         
         */
        NSString *Title = @"更新排版数据";
        UIAlertView *Msg=[[UIAlertView alloc] initWithTitle:Title message:@"请在网络环境良好的情况下执行更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消",nil];
        Msg.alertViewStyle=UIAlertViewStyleDefault;
        [Msg show];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"设置菜单图片 点击");
        [self PickUpImg];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        NSLog(@"还原菜单图片 点击");
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        NSLog(@"给我评分 点击");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreURL]];
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        NSLog(@"功能说明 点击");
        NSString *Title = @"功能说明";
        UIAlertView *Msg=[[UIAlertView alloc] initWithTitle:Title message:UpdateInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        Msg.alertViewStyle=UIAlertViewStyleDefault;
        [Msg show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



/* Table View 构建代码=========================结束
 ============================================================*/


/* 接受服务器回传数据=========================开始
 ============================================================*/

//得到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (connection==RequestConnectionForCus) {
        _RecieveContent = [NSMutableData data];
        NSLog(@"[Request] 得到服务器的响应");
    }
}

//开始接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection==RequestConnectionForCus) {
        [_RecieveContent appendData:data];
        NSLog(@"[Request] 接收到了服务器传回的数据");
    }
}

//错误处理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString * errorinfo;
    if (connection==RequestConnectionForCus) {
        NSLog(@"[Request] 发生错误！");
        errorinfo = [NSString stringWithFormat:@"错误信息：%@",[error localizedDescription]];
        NSString *Title = @"更新失败";
        UIAlertView *Msg=[[UIAlertView alloc] initWithTitle:Title message:errorinfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        Msg.alertViewStyle=UIAlertViewStyleDefault;
        [Msg show];
        [_Loader setHidden:YES];
        [_LabelMsg setHidden:YES];
        [_MasterTableView setHidden:NO];
    }
}

//结束接收数据
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection==RequestConnectionForCus) {
        [self HandleData];
    }
}



/* 接受服务器回传数据=========================结束
 ============================================================*/

-(void)PickUpImg
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"选择了图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)HandleData
{
    NSString * TheContent = [[NSString alloc] initWithData:_RecieveContent encoding:NSUTF8StringEncoding];
    
    NSString * regexstr1 = @"<!--beginconfirm-->";
    NSString * regexstr2 = @"<!--finishconfirm -->";
    NSString * regexstr3 = @"<!--version";
    NSString * regexstr4 = @"end-->";
    NSRange range1 = [TheContent rangeOfString:regexstr1];
    NSRange range2 = [TheContent rangeOfString:regexstr2];
    NSRange range3 = [TheContent rangeOfString:regexstr3];
    NSRange range4 = [TheContent rangeOfString:regexstr4];
    if (
        (range1.location != NSNotFound)&&
        (range2.location != NSNotFound)&&
        (range3.location != NSNotFound)&&
        (range4.location != NSNotFound)&&
        ((range1.location + range1.length) < range2.location)&&
        ((range3.location + range3.length) < range4.location)
        ) {//超级简单的数据校验
        
        NSLog(@"校验通过");
        NSString * TheDateStr = [TheContent substringWithRange:NSMakeRange(range3.location + range3.length, range4.location - range3.location - range3.length)];
        NSString * TheCustomizeStr = [TheContent substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
        
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:TheDateStr forKey:@"CustomizeDate"];
        [defaultdata setObject:TheCustomizeStr forKey:@"CustomizeHTMLContent"];
        [defaultdata synchronize];
        
        NSLog(@"更新数据完成");
        
        NSString *Title = @"更新成功！";
        UIAlertView *Msg=[[UIAlertView alloc] initWithTitle:Title message:@"排版数据已经成功更新！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        Msg.alertViewStyle=UIAlertViewStyleDefault;
        [Msg show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSString *Title = @"更新失败";
        UIAlertView *Msg=[[UIAlertView alloc] initWithTitle:Title message:@"数据校验失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        Msg.alertViewStyle=UIAlertViewStyleDefault;
        [Msg show];
        [_Loader setHidden:YES];
        [_LabelMsg setHidden:YES];
        [_MasterTableView setHidden:NO];
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * tmpstring=[alertView buttonTitleAtIndex:buttonIndex];
    if ([tmpstring isEqualToString:@"更新"]) {//你是否更新？
        [_Loader setHidden:NO];
        [_LabelMsg setHidden:NO];
        [_MasterTableView setHidden:YES];
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:APICustomize] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        [TheRequest setHTTPMethod:@"GET"];
        RequestConnectionForCus = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
    }
}
@end
