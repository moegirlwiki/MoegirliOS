//
//  moegirlSearchSuggestionsTableView.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface moegirlSearchSuggestionsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
{
@private
    NSString * lastKeyword;
    NSURLConnection *requestConnection;
}

- (NSString *)urlEncode:(NSString*)unencodeString;
- (void)checkSuggestions:(NSString *)keyword;

@property (strong, nonatomic) NSString * targetURL;

@property (strong, nonatomic) NSMutableData * recievePool;

@property (strong, nonatomic) NSArray * suggestions;

@end
