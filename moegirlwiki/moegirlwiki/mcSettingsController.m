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
    updateInProgress = NO;
    
    [_HelpWebView setDelegate:self];
    
    //保护视图
    _protectView = [UIView new];
    [_protectView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    [self.view addSubview:_protectView];
    [_protectView setAlpha:0];
    
    //加载模块
    _updateView = [UIView new];
    [_updateView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    [_updateView setFrame:CGRectMake((_MainInitViewRuler.frame.size.width - 100)/2, (_MainInitViewRuler.frame.size.height - 100)/2, 100, 100)];
    _updateView.layer.cornerRadius = 5;
    _updateView.layer.masksToBounds = YES;
    [self.view addSubview:_updateView];
    [_updateView setAlpha:0];
    
    _updateIndicator = [UIActivityIndicatorView new];
    [_updateIndicator setFrame:CGRectMake(40, 30, 20, 20)];
    [_updateIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_updateIndicator startAnimating];
    [_updateView addSubview:_updateIndicator];
    
    _statueLabel = [UILabel new];
    [_statueLabel setFrame:CGRectMake(0, 70, 100, 15)];
    [_statueLabel setTextColor:[UIColor whiteColor]];
    [_statueLabel setTextAlignment:NSTextAlignmentCenter];
    [_statueLabel setText:@"正在更新"];
    [_statueLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [_updateView addSubview:_statueLabel];
    
    
    //登录模块
    _cancelButton = [UIButton new];
    [_cancelButton  setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    [_cancelButton setAlpha:0];
    
    _loginView = [UIView new];
    [_loginView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [_loginView setFrame:CGRectMake((_MainInitViewRuler.frame.size.width - 230)/2, 20, 230, 150)];
    _loginView.layer.cornerRadius = 5;
    _loginView.layer.masksToBounds = YES;
    [self.view addSubview:_loginView];
    [_loginView setAlpha:0];
    
    UILabel * loginLabel = [UILabel new];
    [loginLabel setText:@"登录萌娘百科"];
    [loginLabel setFrame:CGRectMake(14, 12, 150, 18)];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [_loginView addSubview:loginLabel];
    
    _usernameField = [UITextField new];
    [_usernameField setFrame:CGRectMake(30, 40, _loginView.frame.size.width - 60, 30)];
    [_usernameField setPlaceholder:@"用户名"];
    [_usernameField setBackgroundColor:[UIColor whiteColor]];
    _usernameField.layer.cornerRadius = 3;
    _usernameField.layer.masksToBounds = YES;
    [_usernameField setReturnKeyType:UIReturnKeyNext];
    [_usernameField addTarget:self action:@selector(switchToPasswordField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_loginView addSubview:_usernameField];
    
    
    
    _passwordField = [UITextField new];
    [_passwordField setFrame:CGRectMake(30, 75, _loginView.frame.size.width - 60, 30)];
    [_passwordField setPlaceholder:@"密码"];
    [_passwordField setSecureTextEntry:YES];
    [_passwordField setBackgroundColor:[UIColor whiteColor]];
    _passwordField.layer.cornerRadius = 3;
    _passwordField.layer.masksToBounds = YES;
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_passwordField addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_loginView addSubview:_passwordField];
    
    _loginButton = [UIButton new];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithRed:0.878 green:0.98 blue:0.851 alpha:1] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor clearColor]];
    [_loginButton setFrame:CGRectMake(_loginView.frame.size.width - 80, 110, 50, 30)];
    [_loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    _loginButton.layer.borderWidth = 1;
    _loginButton.layer.borderColor = [[UIColor colorWithRed:0.878 green:0.98 blue:0.851 alpha:1] CGColor];
    _loginButton.layer.cornerRadius = 3;
    _loginButton.layer.masksToBounds = YES;
    [_loginView addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    pagecount = 0;
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * folderPath = [[documentPath stringByAppendingPathComponent:@"cache"] stringByAppendingPathComponent:@"page"];
    NSFileManager* manager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        pagecount ++;
    }
    folderSize = folderSize/1024.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    onHelp = NO;
    [self.view sendSubviewToBack:_HelpIndicator];
    [self.view sendSubviewToBack:_HelpWebView];
    
    [_SettingsTable setScrollsToTop:NO];
    [self resizeViews];
}

- (void)resizeViews
{
    [_protectView setFrame:CGRectMake(0, 0, _MainInitViewRuler.frame.size.width, _MainInitViewRuler.frame.size.height)];
    [_cancelButton setFrame:CGRectMake(0, 0, _MainInitViewRuler.frame.size.width, _MainInitViewRuler.frame.size.height)];
    [_updateView setFrame:CGRectMake((_MainInitViewRuler.frame.size.width - 100)/2, (_MainInitViewRuler.frame.size.height - 100)/2, 100, 100)];
    if (_MainInitViewRuler.frame.size.height < _MainInitViewRuler.frame.size.width) {
        [_loginView setFrame:CGRectMake((_MainInitViewRuler.frame.size.width - 230)/2, 20, 230, 150)];
    }else{
        [_loginView setFrame:CGRectMake((_MainInitViewRuler.frame.size.width - 230)/2, 70, 230, 150)];
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resizeViews];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 2;
    }else{
        return 4;
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
            [SwitchItem addTarget:self action:@selector(NoImageMode_Switch:) forControlEvents:UIControlEventValueChanged];
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            [SwitchItem setOn:[defaultdata boolForKey:@"NoImage"]];
            cell.accessoryView = SwitchItem;
        } else if (indexPath.row == 1) {
            //更新排版数据
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"低亮度模式";
            cell.detailTextLabel.text = @"夜间模式将于3.0版正式推出";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            [SwitchItem addTarget:self action:@selector(NightMode_Switch:) forControlEvents:UIControlEventValueChanged];
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            [SwitchItem setOn:[defaultdata boolForKey:@"NightMode"]];
            cell.accessoryView = SwitchItem;
        } else if (indexPath.row == 2) {
            //弹出菜单
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"弹出目录";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *SwitchItem = [[UISwitch alloc] initWithFrame:CGRectZero];
            [SwitchItem addTarget:self action:@selector(PopoutMenu_Switch:) forControlEvents:UIControlEventValueChanged];
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            [SwitchItem setOn:[defaultdata boolForKey:@"PopoutMenu"]];
            cell.accessoryView = SwitchItem;
            
        } else if (indexPath.row == 3) {
            //更新排版数据
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"更新排版数据";
            cell.detailTextLabel.text = @"升级排版数据至最新可以提升浏览体验";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //清除缓存
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"清除本地缓存";
            if (folderSize > 1024) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"已缓存%d个页面，共计%lldMB",pagecount,(folderSize/1024)];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"已缓存%d个页面，共计%lldKB",pagecount,folderSize];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //登录
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"登录";
            
            NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
            NSString * username = [defaultdata objectForKey:@"username"];
            if ([username isEqualToString:@"--"]) {
                cell.detailTextLabel.text = @"当前您是以 游客 身份浏览萌娘百科";
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"您已登录账号 %@",username];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 1) {
            //登录
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"恢复编辑数据";
            cell.detailTextLabel.text = @"点击这里将上次编辑的内容复制到剪贴板";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else {
        if (indexPath.row == 0) {
            //意见反馈
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"帮助与功能说明";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1) {
            //意见反馈
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"反馈问题或建议";
            cell.detailTextLabel.text = @"帮助我们改进程序";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }else if(indexPath.row == 2){
            //给我评分
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"给我评分";
            cell.detailTextLabel.text = @"据说五星评价可以提升程序猿萌化代码的能力";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }else{
            //支持
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.textLabel.text = @"技术支持";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    }
        return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"浏览设置";
    }else if (section == 1){
        return @"缓存";
    }else if (section == 2){
        return @"账户";
    }else{
        return @"其它";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        NSString * info = [NSString stringWithFormat:@"当前版本：%@\n最新版本：%@\n%@\n\n\n\n",[defaultdata objectForKey:@"engine"],[defaultdata objectForKey:@"engine_latest"],[defaultdata objectForKey:@"engine_instruction"]];
        return info;
    }else if (section == 1){
        return @"使用右侧菜单中的刷新可以查看最新更新\n\n\n";
    }else if (section == 2){
        return @"手机端暂时无法提供注册功能\n编辑器目前仅支持[自动确认用户]\n\n\n";
    }else {
        return @"\n\n\n© 2014 Moegirlsaikou Foundation.\nAll rights reserved.";
    }
}

#pragma mark AlertViewAction

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * btnText = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"确定删除"]) {
        [self cleanCache];
        
    }else if ([btnText isEqualToString:@"注销"]){
        NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"--" forKey:@"username"];
        [defaultdata setObject:@"--" forKey:@"cookie"];
        
        //清除Cookies
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookiee in cookies)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookiee];
        }
        
        [_SettingsTable reloadData];
    }else if ([btnText isEqualToString:@"访问Github页面"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/moegirlwiki/MoegirliOS/"]];
    }else if ([btnText isEqualToString:@"确定"]){
        [self cleanCache];
    };
}


#pragma mark TableViewAction

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            
            if (indexPath.row == 3) {
                //更新排版数据
                [self updateStarto];
            }
            
            break;
        case 1:
            
            if (indexPath.row == 0) {
                //清除本地缓存
                NSLog(@"清除本地缓存");
                UIAlertView * cleanConfirm = [[UIAlertView alloc]initWithTitle:@"确定要清除本地缓存吗？"
                                                                       message:@"清除后将需要重新从服务器下载数据"
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                             otherButtonTitles:@"确定删除", nil];
                [cleanConfirm show];
            }
        
            break;
        case 2:

            
            if (indexPath.row == 0) {
                //账户
                NSLog(@"账户");
                
                NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
                NSString * username = [defaultdata objectForKey:@"username"];
                if ([username isEqualToString:@"--"]) {
                    [self showLoginView];
                }else{
                    [self logoutRequest];
                }
                
            }else{
                //恢复内容
                NSLog(@"恢复内容");
                
                NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString * wikitextDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"editorBackup"];
                NSFileManager * fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:wikitextDocumentPath]) {
                    NSString *wikitext = [NSString stringWithContentsOfFile:wikitextDocumentPath encoding:NSUTF8StringEncoding error:nil];
                    //NSLog(@"%@",wikitext);
                    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
                    [pasteBoard setString:wikitext];
                    UIAlertView * successConfirm = [[UIAlertView alloc]initWithTitle:@"恭喜！"
                                                                           message:@"上次编辑的内容已经恢复到了剪贴板，你可以将其复制到其他应用（例如系统自带的［备忘录］）进行备份或进一步处理。"
                                                                          delegate:nil
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"确定", nil];
                    [successConfirm show];
                } else {
                    UIAlertView * errorConfirm = [[UIAlertView alloc]initWithTitle:@"非常抱歉！"
                                                                           message:@"系统中并没有找到备份文件"
                                                                          delegate:nil
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"确定", nil];
                    [errorConfirm show];
                }
                
                
            }
            
            break;
        case 3:
            
            if (indexPath.row == 0) {
                //使用帮助
                
                onHelp = YES;
                [self.view bringSubviewToFront:_HelpWebView];
                [self.view bringSubviewToFront:_HelpIndicator];
                
                NSMutableURLRequest * helpRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://masterchan.me:1024/v22/help.php"]
                                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                            timeoutInterval:60];
                [_HelpWebView loadRequest:helpRequest];
                
                
            }else if (indexPath.row == 1) {
                //反馈问题建议
                NSString * subject = [NSString stringWithFormat:@"萌娘百科反馈v2.5－%@%@-%dx%d",
                                      [[UIDevice currentDevice] systemVersion],
                                      [[UIDevice currentDevice] model],
                                      (int)self.view.frame.size.height,
                                      (int)self.view.frame.size.width
                                      ];
                
                NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
                NSString * body = [NSString stringWithFormat:@"请在这里输入您要反馈的问题或者建议，\n感谢您对本客户端的支持！\n\n识别ID:%@",
                                   [defaultdata objectForKey:@"uuid"]];
                
                NSString * emaillink = [NSString stringWithFormat:@"mailto:contact@masterchan.me?subject=%@&body=%@",[subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emaillink]];
                
            }else if (indexPath.row ==2){
                //评分
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id892053828"]];
            }else{
                
                UIAlertView * aboutConfirm = [[UIAlertView alloc]initWithTitle:@"技术支持"
                                                                       message:@"本应用由Michairm和Illvili提供"
                                                                      delegate:self
                                                             cancelButtonTitle:@"关闭"
                                                             otherButtonTitles:@"访问Github页面", nil];
                [aboutConfirm show];
            }
            
            
            break;
        default:
            break;
    }
}

#pragma mark goBackButton

- (IBAction)goBackButtonClick:(id)sender {
    if (onHelp) {
        [self.view sendSubviewToBack:_HelpWebView];
        [self.view sendSubviewToBack:_HelpIndicator];
        onHelp = NO;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark ActionsForMenu

-(void)NoImageMode_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    [defaultdata setBool:[switchView isOn] forKey:@"NoImage"];
    [defaultdata synchronize];
}

-(void)PopoutMenu_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    [defaultdata setBool:[switchView isOn] forKey:@"PopoutMenu"];
    [defaultdata synchronize];
}

-(void)NightMode_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    [defaultdata setBool:[switchView isOn] forKey:@"NightMode"];
    [defaultdata synchronize];
}

#pragma mark Update
-(void)updateStarto
{
    [_statueLabel setText:@"开始更新"];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_protectView setAlpha:1];
                         [_updateView setAlpha:1];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         updateThread = [mcUpdate new];
                         [updateThread setHook:self];
                         [updateThread launchUpdate];
                         /*----------------------*/
                     }];
}

-(void)mcUpdateChangeLabel:(NSString *)hint
{
    [_statueLabel setText:hint];
}

-(void)mcUpdatdFinished
{
    [UIView animateWithDuration:0.2
                          delay:0.5
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_protectView setAlpha:0];
                         [_updateView setAlpha:0];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         [_SettingsTable reloadData];
                         /*----------------------*/
                     }];
}

#pragma mark 登录相关

- (void)showLoginView
{
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_cancelButton setAlpha:1];
                         [_loginView setAlpha:1];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         
                         /*----------------------*/
                     }];
}


- (void)dismissLoginView
{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_cancelButton setAlpha:0];
                         [_loginView setAlpha:0];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         [_usernameField setText:@""];
                         [_passwordField setText:@""];
                         /*----------------------*/
                     }];
}

- (IBAction)switchToPasswordField:(id)sender
{
    [_passwordField becomeFirstResponder];
}

- (IBAction)loginButtonClick:(id)sender
{
    if (_passwordField.text.length >= 6) {
        [self startLogin:_usernameField.text pw:_passwordField.text];
        [self dismissLoginView];
    } else {
        [self dismissLoginView];
        UIAlertView*loginAlert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:@"请输入符合格式的用户名和密码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [loginAlert show];
    }
}

- (IBAction)cancelButtonClick:(id)sender
{
    NSLog(@"cancel");
    [self dismissLoginView];
}

- (void)startLogin:(NSString *)un pw:(NSString *)pw;
{
    
    [_statueLabel setText:@"正在验证"];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_protectView setAlpha:1];
                         [_updateView setAlpha:1];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         moegirlLogin = [moegirlConnectionLogin new];
                         [moegirlLogin setHook:self];
                         [moegirlLogin SetUsername:un Password:pw];
                         [moegirlLogin StartRequest];
                         /*----------------------*/
                     }];
}

-(void)moegirlConnectionLogin:(bool)success info:(NSString *)info cookie:(NSString *)cookieString
{
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_protectView setAlpha:0];
                         [_updateView setAlpha:0];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         /*----------------------*/
                     }];
    if (success) {
        UIAlertView*loginAlert = [[UIAlertView alloc] initWithTitle:@"登录成功"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [loginAlert show];
        [_SettingsTable reloadData];
    }else{
        UIAlertView*loginAlert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:[NSString stringWithFormat:@"提示信息:%@",info]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [loginAlert show];

    }
}

- (void)logoutRequest
{
    UIAlertView * loginAlert = [[UIAlertView alloc] initWithTitle:@"您确定要注销吗？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"注销", nil];
    [loginAlert show];
}

#pragma 帮助相关
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view sendSubviewToBack:_HelpIndicator];
}

#pragma 清除缓存
- (void)cleanCache
{
    //删除缓存
    
    [_statueLabel setText:@"删除缓存"];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_protectView setAlpha:1];
                         [_updateView setAlpha:1];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                         NSString * folderPath = [[documentPath stringByAppendingPathComponent:@"cache"] stringByAppendingPathComponent:@"page"];
                         NSFileManager* manager = [NSFileManager defaultManager];
                         NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
                         NSString* fileName;
                         int count = 0;
                         while ((fileName = [childFilesEnumerator nextObject]) != nil){
                             NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
                             [manager removeItemAtPath:fileAbsolutePath error:nil];
                             count ++;
                             [self mcUpdateChangeLabel:[NSString stringWithFormat:@"删除 %d/%d",count,pagecount]];
                         }
                         [self mcUpdatdFinished];
                         pagecount = 0;
                         folderSize = 0;
                         /*----------------------*/
                     }];
}

@end
