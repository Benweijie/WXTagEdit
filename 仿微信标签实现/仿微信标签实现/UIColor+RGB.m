//
//  UIColor+RGB.m
//  仿微信标签实现
//
//  Created by 钟伟杰 on 2017/2/4.
//  Copyright © 2017年 钟伟杰. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor *)colorWithRGB:(int)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float) (((rgbValue) & 0xFF0000) >> 16)) / 255.0
                           green:((float) (((rgbValue) & 0x00FF00) >> 8)) / 255.0
                            blue:((float) ((rgbValue) & 0x0000FF)) / 255.0
                           alpha:alpha];
}

@end
