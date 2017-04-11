//
//  LKViewController.m
//  LKBanner
//
//  Created by hlrwlbz123@sina.com on 04/11/2017.
//  Copyright (c) 2017 hlrwlbz123@sina.com. All rights reserved.
//

#import "LKViewController.h"
#import "News.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LKBanner/LkBannerView.h>

@interface LKViewController ()

@property (nonatomic,strong) LkBannerView *bannerView;

@end

@implementation LKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.bannerView.frame = CGRectMake(0, 100, 375, 150);
    self.bannerView.backgroundColor = [UIColor redColor];
    //    self.bannerView.pageIndicatorNormalColor = [UIColor blueColor];
    //    self.bannerView.pageIndicatorSelectColor = [UIColor redColor];
    //    self.bannerView.pageImage = [UIImage imageNamed:@"switch_normal"];
    //    self.bannerView.currentPageImage = [UIImage imageNamed:@"switch_select"];
    self.bannerView.isAutoScroll = NO;
    [self.view addSubview:self.bannerView];
    
    
    NSMutableArray *datas = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        News *news = [[News alloc]init];
        
        if (i % 2== 0) {
            news.imageUrl = [NSURL URLWithString:@"http://fdfs.xmcdn.com/group19/M04/AD/7E/wKgJJle6V2ahiSTZAAEU72DrYKE225.jpg"];
        }else{
            news.imageUrl = [NSURL URLWithString:@"http://fdfs.xmcdn.com/group25/M0B/BF/31/wKgJMVhQtISCKIAiAAXfuScEPoU727.jpg"];
        }
        
        if (i ==3 || i==6) {
            news.imageUrl = [NSURL URLWithString:@"http://fdfs.xmcdn.com/group25/M0B/BF/31/wKgJMVhQtISCKIA"];
        }
        
        news.clickBlock = ^(){
            NSLog(@"当前图片被点击了");
        };
        
        [datas addObject:news];
    }
    self.bannerView.dataSource = datas;
    
    
}


- (LkBannerView *)bannerView{
    
    if (_bannerView == nil) {
        LkBannerView *bannerView = [LkBannerView bannerViewWithLoadImageBlock:^(UIImageView *imageView, NSURL *url) {
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"abc.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    imageView.image = [UIImage imageNamed:@"abc.jpg"];
                }
            }];
        }];
        _bannerView = bannerView;
    }
    return _bannerView;
}

@end
