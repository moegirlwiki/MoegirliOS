//
//  mcImageViewController.h
//  moegirlwiki
//
//  Created by Illvili on 14-10-14.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) NSURL *imageURL;

- (void)loadImageWithURL:(NSURL *)imageURL;

@end
