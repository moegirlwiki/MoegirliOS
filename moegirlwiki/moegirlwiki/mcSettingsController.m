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
@end
