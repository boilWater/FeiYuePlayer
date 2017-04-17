//
//  FYVideoPlayerViewController.m
//  Pods
//
//  Created by liangbai on 2017/4/17.
//
//

#import "FYVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FYPlayerView : UIView

@property(nonatomic, strong) AVPlayer *avPlayer;

@end

@implementation FYPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)avPlayer {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setAvPlayer:(AVPlayer *)avPlayer {
    [(AVPlayerLayer *)[self layer] setPlayer:avPlayer];
}

- (void)dealloc {
    self.avPlayer = nil;
}

@end


@interface FYVideoPlayerViewController ()

@end

@implementation FYVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
