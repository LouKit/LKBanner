//
//  LKBannerProtocol.h
//  LKBanner
//
//  Created by LouKit on 2017/4/7.
//  Copyright © 2017年 LouKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKBannerProtocol <NSObject>

@property (nonatomic, copy, readonly) NSURL *imageUrl;

@property (nonatomic, copy) void(^clickBlock)();


@end
