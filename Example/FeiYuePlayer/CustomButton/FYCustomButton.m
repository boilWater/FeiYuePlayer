//
//  FYCustomButton.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/17.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCustomButton.h"
#import "UIImage+FYImage.h"

@implementation FYCustomButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeBasicParameter];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeBasicParameter];
    }
    return self;
}

#pragma mark -privateMethod

- (void)initializeBasicParameter {
    self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
}

@end
