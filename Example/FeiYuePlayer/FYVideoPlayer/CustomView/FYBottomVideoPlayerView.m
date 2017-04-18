//
//  FYBottomVideoPlayerView.m
//  Pods
//
//  Created by liangbai on 2017/4/18.
//
//

#import "FYBottomVideoPlayerView.h"
#import "FeiYuePlayer-Prefix.pch"

#define BOTTOMVIEW_WIDTH (self.bounds.size.width)
#define BOTTOMVIEW_HEIGHT (self.bounds.size.height)
#define BOTTON_WIDTH (22)
#define BOTTON_HEIGHT (22)
#define LABEL_WIDTH (37)
#define LABEL_HEIGHT (17)
#define ALIGN_BUTTON_PARENT_TOP (10)
#define ALIGN_LABEL_PARENT_LEFTRIGHT (10)
#define ALIGN_LABEL_PARENT_TOP (50)
#define MARGIN_PROGRESS_LEFTRIGHT_IN_BOTTOMVIEW (30)
#define MARGIN_BUTTON_LEFTRIGHT_IN_BUTTOMVIEW (30)

@interface FYBottomVideoPlayerView ()

@property(nonatomic, strong) UILabel *currentTime;
@property(nonatomic, strong) UILabel *remainTime;

@property(nonatomic, strong) UISlider *currentProgress;

@end

@implementation FYBottomVideoPlayerView

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
    [self addSubview:self.playPause];
    [self addSubview:self.fastForward];
    [self addSubview:self.fastReverse];
    [self addSubview:self.nextVideo];
    [self addSubview:self.previousVideo];
    [self addSubview:self.currentProgress];
    [self addSubview:self.currentTime];
    [self addSubview:self.remainTime];
}

#pragma mark -setter & getter

- (UIButton *)playPause {
    if (!_playPause) {
        CGFloat position_X = (BOTTOMVIEW_WIDTH - BOTTON_WIDTH)/2;
        _playPause = [[UIButton alloc] initWithFrame:CGRectMake(position_X, ALIGN_BUTTON_PARENT_TOP, BOTTON_WIDTH, BOTTON_HEIGHT)];
        [_playPause setImage:FYIMAGEWITHNAMED(@"play_nor@2x.png") forState:UIControlStateNormal];
        [_playPause setImage:FYIMAGEWITHNAMED(@"pause_nor@2x.png") forState:UIControlStateSelected];
        _playPause.tag = 0;
    }
    return _playPause;
}

- (UIButton *)fastForward {
    if (!_fastForward) {
        CGFloat position_X = self.playPause.frame.origin.x + MARGIN_BUTTON_LEFTRIGHT_IN_BUTTOMVIEW + BOTTON_WIDTH;
        _fastForward = [[UIButton alloc] initWithFrame:CGRectMake(position_X, ALIGN_BUTTON_PARENT_TOP, BOTTON_WIDTH, BOTTON_HEIGHT)];
        [_fastForward setImage:FYIMAGEWITHNAMED(@"forward_nor@2x.png") forState:UIControlStateNormal];
        [_fastForward setImage:FYIMAGEWITHNAMED(@"forward_disable@2x.png") forState:UIControlStateSelected];
        _fastForward.tag = 1;
    }
    return _fastForward;
}

- (UIButton *)fastReverse {
    if (!_fastReverse) {
        CGFloat position_X = self.playPause.frame.origin.x - MARGIN_BUTTON_LEFTRIGHT_IN_BUTTOMVIEW - BOTTON_WIDTH;
        _fastReverse = [[UIButton alloc] initWithFrame:CGRectMake(position_X, ALIGN_BUTTON_PARENT_TOP, BOTTON_WIDTH, BOTTON_HEIGHT)];
        [_fastReverse setImage:FYIMAGEWITHNAMED(@"backward_nor@2x.png") forState:UIControlStateNormal];
        [_fastReverse setImage:FYIMAGEWITHNAMED(@"backward_disable@2x.png") forState:UIControlStateSelected];
        _fastReverse.tag = 2;
    }
    return _fastReverse;
}

- (UIButton *)nextVideo {
    if (!_nextVideo) {
        CGFloat position_X = self.fastForward.frame.origin.x + MARGIN_BUTTON_LEFTRIGHT_IN_BUTTOMVIEW + BOTTON_WIDTH;
        _nextVideo = [[UIButton alloc] initWithFrame:CGRectMake(position_X, ALIGN_BUTTON_PARENT_TOP, BOTTON_WIDTH, BOTTON_HEIGHT)];
        [_nextVideo setImage:FYIMAGEWITHNAMED(@"fast_forward_nor@2x.png") forState:UIControlStateNormal];
        [_nextVideo setImage:FYIMAGEWITHNAMED(@"fast_forward_disable@2x.png") forState:UIControlStateSelected];
        _nextVideo.tag = 3;
    }
    return _nextVideo;
}

- (UIButton *)previousVideo {
    if (!_previousVideo) {
        CGFloat position_X = self.fastReverse.frame.origin.x - MARGIN_BUTTON_LEFTRIGHT_IN_BUTTOMVIEW - BOTTON_WIDTH;
        _previousVideo = [[UIButton alloc] initWithFrame:CGRectMake(position_X, ALIGN_BUTTON_PARENT_TOP, BOTTON_WIDTH, BOTTON_HEIGHT)];
        [_previousVideo setImage:FYIMAGEWITHNAMED(@"fast_backward_nor@2x.png") forState:UIControlStateNormal];
        [_previousVideo setImage:FYIMAGEWITHNAMED(@"fast_backward_disable@2x.png") forState:UIControlStateSelected];
        _previousVideo.tag = 4;
    }
    return _previousVideo;
}

- (UILabel *)currentTime {
    if (!_currentTime) {
        _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(ALIGN_LABEL_PARENT_LEFTRIGHT, ALIGN_LABEL_PARENT_TOP, LABEL_WIDTH, LABEL_HEIGHT)];
        _currentTime.font = [UIFont systemFontOfSize:14.0];
        _currentTime.textColor = [UIColor darkGrayColor];
        _currentTime.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTime;
}

- (UILabel *)remainTime {
    if (!_remainTime) {
        CGFloat position_X = BOTTOMVIEW_WIDTH - LABEL_WIDTH - ALIGN_LABEL_PARENT_LEFTRIGHT;
        _remainTime = [[UILabel alloc] initWithFrame:CGRectMake(position_X, ALIGN_LABEL_PARENT_TOP, LABEL_WIDTH, LABEL_HEIGHT)];
        _remainTime.font = [UIFont systemFontOfSize:14.0];
        _remainTime.textColor = [UIColor darkGrayColor];
        _remainTime.textAlignment = NSTextAlignmentCenter;
    }
    return _remainTime;
}

- (UISlider *)currentProgress {
    if (!_currentProgress) {
        CGFloat position_X = ALIGN_LABEL_PARENT_LEFTRIGHT + LABEL_WIDTH + MARGIN_PROGRESS_LEFTRIGHT_IN_BOTTOMVIEW;
        _currentProgress = [[UISlider alloc] initWithFrame:CGRectMake(position_X, ALIGN_LABEL_PARENT_TOP + LABEL_HEIGHT/2, BOTTOMVIEW_WIDTH - position_X * 2, LABEL_HEIGHT)];
    }
    return _currentProgress;
}



@end
