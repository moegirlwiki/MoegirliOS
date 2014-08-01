//
//  mcReportController.m
//  moegirlwiki
//
//  Created by Chen Junlin on 14-7-30.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcReportController.h"

@interface mcReportController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *DoneBarButton;
@property (weak, nonatomic) IBOutlet UITextField *issueText;
@property (weak, nonatomic) IBOutlet UITextField *contactEmail;
- (IBAction)issueSelectButton:(id)sender;
- (IBAction)SendReport:(id)sender;
- (IBAction)CancelReport:(id)sender;
- (IBAction)readyToSend:(id)sender;

-(void)SendFunction;
@end

@implementation mcReportController

@synthesize rtitle;
@synthesize rcontent;
@synthesize rerror;

NSArray * issueList;

NSString * ReportAPI = @"https://masterchan.me/moegirlwiki/debug/send1.3.php";
//发送错误报告的链接

NSTimeInterval ReportRequestTimeOutSec = 20;

NSURLConnection * ReportRequestConnection;

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
    [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    issueList = [NSArray arrayWithObjects:
                 @"请选择...",
                 @"页面无法完成加载",
                 @"页面排版错误",
                 @"词条不完善",
                 @"词条描述有误，请求修正",
                 @"词条违反有关规定",nil];
    _thePicker.delegate = self;
    NSUserDefaults *DefaultData = [NSUserDefaults standardUserDefaults];
    if ([DefaultData objectForKey:@"email"] != nil) {
        _contactEmail.text = [DefaultData objectForKey:@"email"];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [_issueText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return issueList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [issueList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[issueList objectAtIndex:row]isEqualToString:@"请选择..."]) {
        [_DoneBarButton setEnabled:NO];
        [_issueText setText:@""];
    } else {
        [_issueText setText:[issueList objectAtIndex:row]];
        [_DoneBarButton setEnabled:YES];
    }
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

- (IBAction)issueSelectButton:(id)sender {
    [_issueText resignFirstResponder];
    [_contactEmail resignFirstResponder];
    [_thePicker setHidden:NO];
}

- (IBAction)SendReport:(id)sender {
    [self SendFunction];
}

- (IBAction)CancelReport:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)readyToSend:(id)sender {
    if ((![[_issueText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])&&([_issueText text].length > 2)) {
        [_DoneBarButton setEnabled:YES];
    }else{
        [_DoneBarButton setEnabled:NO];
    }
}


-(void)SendFunction{
    //发送错误报告
    NSString *RequestURL = ReportAPI;
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:ReportRequestTimeOutSec];
    [TheRequest setHTTPMethod:@"POST"];
    NSData * data = [[NSString stringWithFormat:@"i=%@&e=%@&t=%@&c=%@&r=%@",[_issueText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_contactEmail.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[rtitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[rcontent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[rerror stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding];
    [TheRequest setHTTPBody:data];
    ReportRequestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:nil];
    
    //提示信息
    NSString *Title = @" 谢谢！";
    UIAlertView *ReportWarning=[[UIAlertView alloc] initWithTitle:Title message:@"感谢您对萌娘百科的支持！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    ReportWarning.alertViewStyle=UIAlertViewStyleDefault;
    [ReportWarning show];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //保存默认邮箱
    NSUserDefaults *DefaultData = [NSUserDefaults standardUserDefaults];
    [DefaultData setObject:_contactEmail.text forKey:@"email"];
    [DefaultData synchronize];
}
@end
