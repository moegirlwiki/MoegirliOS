//
//  mcAnalytics.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/25.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcUpdate.h"

@interface mcAnalytics : UIWebView<UIWebViewDelegate>
{
    @private
    NSURLConnection *requestConnection;
    NSURL *AnalyticURL;
    mcUpdate *SlienceUpdateThread;//由于更新包不大，因此静默更新更加方便上线期间修改bug
}

- (void)startRequest;
@property (strong, nonatomic) NSString *viewSize;
@property (strong, nonatomic) NSMutableData * recievePool;

@end
