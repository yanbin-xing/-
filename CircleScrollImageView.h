//
//  CircleScrollImageView.h
//  MyProject
//
//  Created by xyb on 2017/12/8.
//  Copyright © xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleScrollImageViewDelegate <NSObject>

- (void)onShowContentAtIndex:(NSInteger)index;
- (void)onTouchAtIndex:(NSInteger)index;
@end

@interface CircleScrollImageView : UIView

@property (assign, nonatomic) id<CircleScrollImageViewDelegate> delegate;
@property (strong, nonatomic) NSArray *imgUrls;
@property (strong, nonatomic) NSTimer *timer;
@end
