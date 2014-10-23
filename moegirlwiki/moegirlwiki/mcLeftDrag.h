//
//  mcLeftDrag.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mcLeftDragDelegate<NSObject>
-(void)MoveMainViewByLeftBegan;
-(void)MoveMainViewByLeft:(float)Position;
-(void)MoveMainViewByLeftEnded:(BOOL)Dismiss;
@end

@interface mcLeftDrag : UIView
{
    CGPoint startPoint;
}

@property float offSetX;
@property (assign, nonatomic) id<mcLeftDragDelegate> hook;

@end
