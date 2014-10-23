//
//  moegirlMainPageScrollView.h
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol moegirlMainPageScrollViewDekegate <NSObject>

- (void)progressAndStatusShowUp;
- (void)progressAndStatusHide;
- (void)progressAndStatusMakeStep:(float)step info:(NSString *)info;
- (void)progressAndStatusSetToValue:(float)step info:(NSString *)info;
- (void)cancelKeyboard;

@end

@interface moegirlMainPageScrollView : UIScrollView<UITextViewDelegate,UIScrollViewDelegate>
{
    @private
        bool usingCache;
        NSURLConnection * requestConnection;
    
}

- (void)refreshScrollView;
- (void)setupScrollView;
- (void)setupHeadBanner;
- (void)presentError:(NSString *)info;
- (NSAttributedString *)transFormat:(NSString *)initString;
- (void)processRawData:(NSString *)data;
- (void)loadMainPage:(BOOL)useCache;

@property (strong, nonatomic) NSString * targetURL;
@property (strong, nonatomic) NSString * lastRefreshDateTime;

@property (strong, nonatomic) UIView * scrollHeadBanner;
@property (strong, nonatomic) UILabel * scrollHeadHint1;
@property (strong, nonatomic) UILabel * scrollHeadHint2;


@property (strong, nonatomic) NSMutableArray * scrollItemsPanel;
@property (strong, nonatomic) NSMutableArray * scrollItemsTitle;
@property (strong, nonatomic) NSMutableArray * scrollItemsContent;

@property (strong, nonatomic) NSMutableArray * mainPageTitle;
@property (strong, nonatomic) NSMutableArray * mainPageContent;

@property (strong,nonatomic) NSMutableData * recievePool;

@property (assign, nonatomic) id<moegirlMainPageScrollViewDekegate> hook;

@end


@interface mcListOfTags : NSObject

@property (assign, nonatomic) NSInteger position;
@property (retain, nonatomic) NSString * tag;

@end