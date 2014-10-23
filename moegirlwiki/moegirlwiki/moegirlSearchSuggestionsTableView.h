//
//  moegirlSearchSuggestionsTableView.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol moegirlSearchSuggestionsTableViewDelegate <NSObject>

- (void)cancelKeyboard;
- (void)newWebViewRequestFormSuggestions:(NSString *)keyword;

@end

@interface moegirlSearchSuggestionsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
{
@private
    NSString * lastKeyword;
    NSURLConnection *requestConnection;
    bool firstTime;
}

- (NSString *)urlEncode:(NSString*)unencodeString;
- (void)checkSuggestions:(NSString *)keyword;

@property (strong, nonatomic) NSString * targetURL;

@property (strong, nonatomic) NSMutableData * recievePool;

@property (strong, nonatomic) NSArray * suggestions;

@property (assign, nonatomic) id<moegirlSearchSuggestionsTableViewDelegate> hook;

@end
