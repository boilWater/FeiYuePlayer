//
//  UIImage+FYImage.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/18.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "UIImage+FYImage.h"

@implementation UIImage (FYImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
