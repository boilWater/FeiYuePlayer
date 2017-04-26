//
//  FYEditorPlayerViewController.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/27.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYEditorPlayerViewController.h"
#import "FeiYuePlayer-Prefix.pch"

static void *playerItemStatusContext = &playerItemStatusContext;

@interface FYEditorPlayerViewController ()<UIAlertViewDelegate>{
    CGFloat startCMTime;
    CGFloat endCMTime;
}

@property(nonatomic, strong) AVPlayer *mPlayer;
@property(nonatomic, strong) AVPlayerItem *mPlayerItem;
@property(nonatomic, strong) UISlider *startSlider;
@property(nonatomic, strong) UISlider *endSlider;

@end

@implementation FYEditorPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlizerCustomParamter];
    
    [self.view addSubview:self.startSlider];
    [self.view addSubview:self.endSlider];
    
    [self initlizerPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [self.mPlayer pause];
    [self removeObserver:self forKeyPath:@"mPlayerItem.status" context:playerItemStatusContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    self.mPlayer = nil;
    self.mPlayerItem = nil;
    self.mPlayerView = nil;
}

#pragma mark -
#pragma mark -privatedMethod(initlizerCustomParamter)

- (void)initlizerCustomParamter {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initlizerPlayer {
    if (!self.urlSelectedVideo) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有选着视频" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView show];
    }else {
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:self.urlSelectedVideo options:nil];
        self.mPlayerItem = [[AVPlayerItem alloc] initWithAsset:urlAsset];
        self.mPlayer = [[AVPlayer alloc] initWithPlayerItem:self.mPlayerItem];
        [self.mPlayerView setMBasePlayer:self.mPlayer];
        [self.startPlayer addTarget:self action:@selector(startPlayerVideo:) forControlEvents:UIControlEventTouchDown];
    }
    [self addObserver:self forKeyPath:@"mPlayerItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:playerItemStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rePlayVideoWithPlayItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == playerItemStatusContext) {
        
    }
}

#pragma mark -
#pragma mark -privatedMethod(ClickMethod)

- (void)rePlayVideoWithPlayItemDidPlayToEndTime {
    [self.mPlayerItem seekToTime:kCMTimeZero];
}

- (void)startPlayerVideo:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        [self.mPlayer play];
        [self.startPlayer setTitle:@"暂停" forState:UIControlStateNormal];
    }else if ([sender.titleLabel.text isEqualToString:@"暂停"]){
        [self.mPlayer pause];
        [self.startPlayer setTitle:@"播放" forState:UIControlStateNormal];
    }else {
        [self.mPlayer play];
    }
}

- (void)sliderEditorVideo:(UISlider *)slider {
    switch (slider.tag) {
        case 0:
        {
            NSLog(@"startCMTime : %f", slider.value);
            break;
        }
        case 1:
        {
            NSLog(@"endCMTime : %f", slider.value);
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark -UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark -setter & getter

- (UISlider *)startSlider {
    if (!_startSlider) {
        CGFloat positionY = self.mPlayerView.frame.origin.y + self.mPlayerView.bounds.size.height + 30;
        _startSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, positionY, SCREEN_WIDTH - 20 * 2, 10)];
        _startSlider.tag = 1;
        [_startSlider addTarget:self action:@selector(sliderEditorVideo:) forControlEvents:UIControlEventTouchDown];
    }
    return _startSlider;
}

- (UISlider *)endSlider {
    if (!_endSlider) {
        CGFloat positionY = self.mPlayerView.frame.origin.y + self.mPlayerView.bounds.size.height + 70;
        _endSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, positionY, SCREEN_WIDTH - 20 * 2, 10)];
        _endSlider.tag = 2;
        [_endSlider addTarget:self action:@selector(sliderEditorVideo:) forControlEvents:UIControlEventTouchDown];
    }
    return _endSlider;
}

@end
