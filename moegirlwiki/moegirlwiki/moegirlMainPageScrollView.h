//
//  moegirlMainPageScrollView.h
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface moegirlMainPageScrollView : UIScrollView<UITextViewDelegate>
{
    @private
        NSURLConnection *requestConnection;
    
}

- (void)refreshScrollView;
- (void)setupScrollView;
- (void)presentError:(NSString *)info;
- (NSAttributedString *)transFormat:(NSString *)initString;
- (void)processRawData:(NSString *)data;
- (void)loadMainPage:(NSString *)targetURL useCache:(BOOL)useCache;

@property (strong, nonatomic) NSString * lastRefreshDateTime;
@property (strong, nonatomic) NSMutableArray * scrollItemsPanel;
@property (strong, nonatomic) NSMutableArray * scrollItemsTitle;
@property (strong, nonatomic) NSMutableArray * scrollItemsContent;
@property (strong, nonatomic) NSMutableArray * mainPageTitle;
@property (strong, nonatomic) NSMutableArray * mainPageContent;
@property (strong,nonatomic) NSMutableData * recievePool;

@end


@interface mcListOfTags : NSObject

@property (assign, nonatomic) NSInteger position;
@property (retain, nonatomic) NSString * tag;

@end