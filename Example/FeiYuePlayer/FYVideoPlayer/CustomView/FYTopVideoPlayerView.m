//
//  FYTopVideoPlayerView.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/18.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYTopVideoPlayerView.h"

#define ALIGN_LABEL_PARENT_LEFTRIGHT (8)
#define ALIGN_LABEL_PARENT_TOPBOTTOM (7)
#define BUTTON_WIGTH_HEIGHT (30)
#define LABEL_HEIGHT (30)
#define LABEL_WIDTH (60)

@interface FYTopVideoPlayerView ()

@property(nonatomic, strong) UILabel *titleTopView;

@end

@implementation FYTopVideoPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialerBasicParamter];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialerBasicParamter];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc is release %s in class %@", __func__, [self class]);
}

#pragma mark -privateMethod

- (void)initialerBasicParamter {
    self.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.cancelPlayer];
    [self addSubview:self.titleTopView];
}

#pragma mark -setter & getter

- (UIButton *)cancelPlayer {
    if (!_cancelPlayer) {
        _cancelPlayer = [[UIButton alloc] initWithFrame:CGRectMake(ALIGN_LABEL_PARENT_LEFTRIGHT, ALIGN_LABEL_PARENT_TOPBOTTOM, BUTTON_WIGTH_HEIGHT, BUTTON_WIGTH_HEIGHT)];
        [_cancelPlayer setTitle:@"返回" forState:UIControlStateNormal];
        _cancelPlayer.tag = 5;
    }
    return _cancelPlayer;
}

- (UILabel *)titleTopView {
    if (!_titleTopView) {
        CGFloat postion_X = (SCREEN_WIDTH - LABEL_WIDTH)/2;
        CGFloat postion_Y = (SCREEN_HEIGHT - LABEL_HEIGHT)/2;
        _titleTopView = [[UILabel alloc] initWithFrame:CGRectMake(postion_X, postion_Y, LABEL_WIDTH, LABEL_HEIGHT)];
        _titleTopView.font = [UIFont systemFontOfSize:14.0];
        _titleTopView.backgroundColor = [UIColor whiteColor];
    }
    return _titleTopView;
}


@end
