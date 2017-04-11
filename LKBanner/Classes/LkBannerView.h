//
//  LkBannerView.h
//  LKBanner
//
//  Created by LouKit on 2017/4/7.
//  Copyright © 2017年 LouKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBannerProtocol.h"

typedef void(^LoadImageBlock)(UIImageView *imageView, NSURL *url);

@protocol LKBannerViewDelegate <NSObject>

- (void)bannerViewDidSelected: (id <LKBannerProtocol>)banner;

@end

@interface LkBannerView : UIView

+ (instancetype)bannerViewWithLoadImageBlock: (LoadImageBlock)loadBlock;

/**
 *banner 选中时代理
 */
@property (nonatomic, strong) id<LKBannerViewDelegate> delegate;

/**
 *banner 数据源
 */
@property (nonatomic, strong) NSArray <id <LKBannerProtocol>> *dataSource;

/**
 *是否需要自动滚动
 */
@property (nonatomic,assign) BOOL isAutoScroll;

/**
 *指示器默认颜色
 */
@property (nonatomic,strong) UIColor *pageIndicatorNormalColor;

/**
 *指示器选中颜色
 */
@property (nonatomic,strong) UIColor *pageIndicatorSelectColor;

/**
 *指示器默认图片
 */
@property (nonatomic,strong) UIImage *pageImage;

/**
 *指示器选中图片
 */
@property (nonatomic,strong) UIImage *currentPageImage;

@end
