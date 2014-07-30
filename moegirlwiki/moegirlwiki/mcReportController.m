//
//  mcReportController.m
//  moegirlwiki
//
//  Created by Chen Junlin on 14-7-30.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcReportController.h"

@interface mcReportController ()
@property (weak, nonatomic) IBOutlet UITextField *issueText;

@end

@implementation mcReportController

NSArray * issueList;

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
    issueList = [NSArray arrayWithObjects:
                 @"页面无法完成加载",
                 @"页面排版错误",
                 @"词条不完善",
                 @"词条违反有关规定",
                 @"其它",nil];
    //_thePicker.dataSource = self;
    _thePicker.delegate = self;
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
    [_issueText setText:[issueList objectAtIndex:row]];
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

@end
