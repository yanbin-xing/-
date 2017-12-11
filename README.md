# CircleScrollImageView
实现无限循环的自动图片轮播

一、代码集成：
//初始化
CircleScrollImageView *imgScrollView = [[CircleScrollImageView alloc] initWithFrame:CGRectMakeCGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//设置图片链接
[imgScrollView setImgUrls:@[@"",@"",@""]];

二、回调处理
CircleScrollImageViewDelegate
//当前展示图片索引，用于定制UIPageControl
- (void)onShowContentAtIndex:(NSInteger)index;
//被点击图片索引
- (void)onTouchAtIndex:(NSInteger)index;
