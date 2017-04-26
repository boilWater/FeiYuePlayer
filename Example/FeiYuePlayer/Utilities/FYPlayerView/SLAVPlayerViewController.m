//
//  SLAVPlayerViewController.m
//  PROJECT
//
//  Created by liangbai on 2017/4/26.
//  Copyright © 2017年 PROJECT_OWNER. All rights reserved.
//

#import "SLAVPlayerViewController.h"
#import "FeiYuePlayer-Prefix.pch"

@implementation SLPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)mBasePlayer {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setMBasePlayer:(AVPlayer *)mBasePlayer {
    [(AVPlayerLayer *)[self layer] setPlayer:mBasePlayer];
}

- (void)dealloc {
    self.mBasePlayer = nil;
}

@end

@interface SLAVPlayerViewController ()

@end

@implementation SLAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mPlayerView];
    [self.view addSubview:self.startPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark -setter & getter 

- (SLPlayerView *)mPlayerView {
    if (!_mPlayerView) {
        CGFloat positionY = 60;
        _mPlayerView = [[SLPlayerView alloc] initWithFrame:CGRectMake(0, positionY, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 240)];
        _mPlayerView.backgroundColor = [UIColor yellowColor];
    }
    return _mPlayerView;
}

- (UIButton *)startPlayer {
    if (!_startPlayer) {
        CGFloat positionX = (SCREEN_WIDTH - 60)/2;
        CGFloat positionY = self.mPlayerView.bounds.size.height + 20;
        _startPlayer = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, 60, 35)];
        _startPlayer.backgroundColor = [UIColor redColor];
        _startPlayer.alpha = 0.5f;
        [_startPlayer setTitle:@"播放" forState:UIControlStateNormal];
    }
    return _startPlayer;
}


@end
