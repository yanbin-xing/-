
//
//  CircleScrollImageView.m
//  SenXianBao
//
//  Created by administrator on 2017/12/8.
//  Copyright © 2017年 IOS Develope Team. All rights reserved.
//

#import "CircleScrollImageView.h"
#import "UIImageView+WebCache.h"

@interface CircleScrollImageView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imgViews;
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) NSInteger curIndex;
@end

@implementation CircleScrollImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
        [_scrollView addGestureRecognizer:gesture];
        
        _imgViews = [NSMutableArray array];
        CGFloat beginX = 0;
        for (NSInteger i=0; i<3; i++)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(beginX, 0, frame.size.width, frame.size.height)];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [_scrollView addSubview:imgView];
            imgView.userInteractionEnabled = YES;
            [_imgViews addObject:imgView];
            beginX += frame.size.width;
        }
        [_scrollView setContentSize:CGSizeMake(beginX, frame.size.height)];
        _scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        [self addObserver:self  
               forKeyPath:@"imgUrls" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"imgUrls"])
    {
        NSArray *imgUrls = [change objectForKey:NSKeyValueChangeNewKey];
        self.totalCount = [imgUrls count];
        self.curIndex = 0;
        
        [self reloadContent];
        if (!_timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoChanged) userInfo:nil repeats:YES];
        }
    }
}

- (void)autoChanged
{
    ///此处设置动画的时间一定要小于滑动的时间
    [UIView animateWithDuration:0.5 animations:^{
        ///动画发生的滑动
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, 0);
    } completion:^(BOOL finished) {
        [self reloadScrollView];
    }];
}

- (void)reloadContent
{
    if (_delegate && [_delegate respondsToSelector:@selector(onShowContentAtIndex:)])
    {
        [_delegate onShowContentAtIndex:_curIndex];
    }
    NSString *curUrl = [_imgUrls objectAtIndex:_curIndex];
    UIImageView *imgView = [_imgViews objectAtIndex:1];
    [imgView sd_setImageWithURL:[NSURL URLWithString:curUrl]];
    
    NSString *foreUrl = [_imgUrls objectAtIndex:[self foreIndex]];
    imgView = [_imgViews objectAtIndex:0];
    [imgView sd_setImageWithURL:[NSURL URLWithString:foreUrl]];
    
    NSString *backUrl = [_imgUrls objectAtIndex:[self backIndex]];
    imgView = [_imgViews objectAtIndex:2];
    [imgView sd_setImageWithURL:[NSURL URLWithString:backUrl]];
}

- (NSInteger)foreIndex
{
    return (_curIndex+_totalCount-1)%_totalCount;
}

- (NSInteger)backIndex
{
    return (_curIndex+1)%_totalCount;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //暂停
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //回到中间一张图片
{
    //继续
    [self reloadScrollView];
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoChanged) userInfo:nil repeats:YES];
    }
}

- (void)reloadScrollView
{
    _curIndex += (_scrollView.contentOffset.x/self.frame.size.width-1)+_totalCount;
    _curIndex = _curIndex%_totalCount;
    //scroll回到中间位置
    [self reloadContent];
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}

- (void)tapView
{
    if (_delegate && [_delegate respondsToSelector:@selector(onTouchAtIndex:)])
    {
        [_delegate onTouchAtIndex:_curIndex];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"imgUrls" context:nil];
}
@end
