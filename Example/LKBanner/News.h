//
//  News.h
//  LKBanner
//
//  Created by LouKit on 2017/4/7.
//  Copyright © 2017年 LouKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKBannerProtocol.h"

@interface News : NSObject<LKBannerProtocol>

@property (nonatomic, copy) NSURL *imageUrl;

@property (nonatomic, copy) void(^clickBlock)();


@end
