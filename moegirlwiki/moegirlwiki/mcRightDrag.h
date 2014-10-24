//
//  mcRightDrag.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mcRightDragDelegate<NSObject>
-(void)MoveMainViewByRightBegan;
-(void)MoveMainViewByRight:(float)Position;
-(void)MoveMainViewByRightEnded:(BOOL)Dismiss;
@end

@interface mcRightDrag : UIView
{
    CGPoint startPoint;
}

@property float offSetX;
@property (assign, nonatomic) id<mcRightDragDelegate> hook;

@end
