//
//  LkBannerView.m
//  LKBanner
//
//  Created by LouKit on 2017/4/7.
//  Copyright © 2017年 LouKit. All rights reserved.
//

#import "LkBannerView.h"

#define kAutoScrollTimeInterval 3

static NSInteger const radio = 10;

@interface LkBannerView ()<UIScrollViewDelegate>
{
    NSInteger _currentPageIndex;
}

@property (nonatomic, strong) NSMutableArray <UIImageView *> *imageDatas;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, copy) LoadImageBlock loadImageBlock;

@end

@implementation LkBannerView

+ (instancetype)bannerViewWithLoadImageBlock:(LoadImageBlock)loadBlock{

    LkBannerView *bannerView = [[LkBannerView alloc]init];
    bannerView.loadImageBlock = loadBlock;

    return bannerView;
}

//数据源
- (void)setDataSource:(NSArray<id<LKBannerProtocol>> *)dataSource{
    _dataSource = dataSource;
    
    [self.imageDatas makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.imageDatas = nil;
    
    NSInteger baseCount = dataSource.count;
    NSInteger count = baseCount;
    if (baseCount > 1) {
        count = baseCount * radio;
    }
    
    for (int i = 0; i< count; i++) {
        
        id<LKBannerProtocol> bannerModel = dataSource[i % baseCount];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = self.imageDatas.count;
        
        if (self.loadImageBlock) {
            self.loadImageBlock(imageView, bannerModel.imageUrl);
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLink:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        [self.contentView addSubview:imageView];
        [self.imageDatas addObject:imageView];
    }
    
    self.pageControl.numberOfPages = dataSource.count;
    
    [self setNeedsLayout];
    
    if (dataSource.count > 1) {
        [self.scrollTimer fire];
    }else {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}


- (void)jumpToLink:(UITapGestureRecognizer *)gester {
    
    UIView *imageView = gester.view;
    NSInteger tag = imageView.tag % self.dataSource.count;
    id<LKBannerProtocol> bannerModel = self.dataSource[tag];
    
    if (bannerModel.clickBlock != nil) {
        bannerModel.clickBlock();
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    
    NSInteger count = self.imageDatas.count;
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    for(int i = 0;i < count;i++) {
        UIImageView *imageView = self.imageDatas[i];
        imageView.frame = CGRectMake(i * width, 0, width, height);
        
    }
    
    self.contentView.contentSize = CGSizeMake(width * count, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
}

#pragma mark - UISCrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.imageDatas.count > 1) {
        [self scrollTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self caculateCurrentPage:scrollView];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self caculateCurrentPage:scrollView];
    
}

- (void)caculateCurrentPage: (UIScrollView *)scrollView {
    
    if (self.dataSource.count == 0) {
        return;
    }
    if (self.dataSource.count == 1) {
        _currentPageIndex = 1;
        if ([self.delegate respondsToSelector:@selector(bannerViewDidSelected:)]) {
            [self.delegate bannerViewDidSelected:self.dataSource[self.pageControl.currentPage]];
        }
        return;
    }
    // 确认中间区域
    NSInteger min = self.dataSource.count * (radio / 2);
    NSInteger max = self.dataSource.count * (radio / 2 + 1);
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page % self.dataSource.count;
    
    if (page < min || page > max) {
        page = min + page % self.dataSource.count;
        [scrollView setContentOffset:CGPointMake(page * scrollView.frame.size.width, 0)];
    }
    
    _currentPageIndex = page;
    
    if ([self.delegate respondsToSelector:@selector(bannerViewDidSelected:)]) {
        [self.delegate bannerViewDidSelected:self.dataSource[self.pageControl.currentPage]];
    }
 
}

#pragma -mark pageControl 圆点样式设置

- (void)setPageIndicatorNormalColor:(UIColor *)pageIndicatorNormalColor{
    _pageIndicatorNormalColor = pageIndicatorNormalColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorNormalColor;
    
}

- (void)setPageIndicatorSelectColor:(UIColor *)pageIndicatorSelectColor{
    _pageIndicatorSelectColor = pageIndicatorSelectColor;
    self.pageControl.currentPageIndicatorTintColor = pageIndicatorSelectColor;
    
}

-(void)setPageImage:(UIImage *)pageImage{
    _pageImage = pageImage;
    [self.pageControl setValue:pageImage forKeyPath:@"pageImage"];

}

-(void)setCurrentPageImage:(UIImage *)currentPageImage{
    _currentPageImage = currentPageImage;
    [self.pageControl setValue:currentPageImage forKeyPath:@"currentPageImage"];

}


#pragma -mark lazy

- (NSTimer *)scrollTimer{

    //是否需要自动滚动
    if(!self.isAutoScroll){
        return nil;
    }
    
    if (_scrollTimer == nil) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoScrollTimeInterval target:self selector:@selector(autoScrollNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    }
    return _scrollTimer;
}

- (void)autoScrollNextPage {
    NSInteger page = _currentPageIndex + 1;
    [self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width * page, 0) animated:YES];
}

- (UIPageControl *)pageControl{

    if (_pageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIScrollView *)contentView{
    
    if (_contentView == nil) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.pagingEnabled = YES;
        contentView.showsHorizontalScrollIndicator = NO;
        _contentView = contentView;
        _contentView.delegate = self;
        [self insertSubview:contentView atIndex:0];
    }
    return _contentView;
}

- (NSMutableArray<UIImageView *> *)imageDatas{

    if (_imageDatas == nil) {
        _imageDatas = [NSMutableArray array];
    }
    return _imageDatas;
}
@end
