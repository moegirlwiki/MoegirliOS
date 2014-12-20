//
//  mcAnalytics.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/25.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcAnalytics : UIWebView<UIWebViewDelegate>
{
    @private
    NSURLConnection *requestConnection;
    NSURL *AnalyticURL;
}

- (void)startRequest;
@property (strong, nonatomic) NSString *viewSize;
@property (strong, nonatomic) NSMutableData * recievePool;

@end
