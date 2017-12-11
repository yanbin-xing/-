//
//  CircleScrollImageView.h
//  MyProject
//
//  Created by xyb on 2017/12/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleScrollImageViewDelegate <NSObject>

- (void)onShowContentAtIndex:(NSInteger)index;
- (void)onTouchAtIndex:(NSInteger)index;
@end

@interface CircleScrollImageView : UIView

@property (assign, nonatomic) id<CircleScrollImageViewDelegate> delegate;
@property (strong, nonatomic) NSArray *imgUrls;
@end
