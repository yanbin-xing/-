//
//  CircleScrollImageView.h
//  SenXianBao
//
//  Created by administrator on 2017/12/8.
//  Copyright © 2017年 IOS Develope Team. All rights reserved.
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
