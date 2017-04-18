//
//  FYVideoPlayerViewController.m
//  Pods
//
//  Created by liangbai on 2017/4/17.
//
//

#import "FYVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FYBottomVideoPlayerView.h"
#import "FYTopVideoPlayerView.h"
#import "FeiYuePlayer-Prefix.pch"

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

#define BOTTOMVIEW_HEIGHT (75)
#define TOPVIEW_HEIGHT (44)

@interface FYVideoPlayerViewController () {
    CGFloat screen_width;
    CGFloat screen_height;
}

@property(nonatomic, strong) NSURL *mVideoURL;
@property(nonatomic, strong) FYBottomVideoPlayerView *bottomView;
@property(nonatomic, strong) FYTopVideoPlayerView *topView;

@end

@implementation FYVideoPlayerViewController

- (instancetype)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.mVideoURL = [url copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializerCustomParamter];
    [self.view addSubview:self.bottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -privateMethod

- (void)initializerCustomParamter {
    self.view.backgroundColor = [UIColor whiteColor];
    screen_width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    screen_height = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)touchDownViewPlayerButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0: //playPause
        {
            break;
        }
        case 1: //fastForward
        {
            break;
        }
        case 2: //fastReverse
        {
            break;
        }
        case 3: //nextVideo
        {
            break;
        }
        case 4: //previousVideo
        {
            break;
        }
        case 5: //previousVideo
        {
            break;
        }

            
        default:
            break;
    }
}

#pragma mark -setter & getter

- (FYBottomVideoPlayerView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[FYBottomVideoPlayerView alloc] initWithFrame:CGRectMake(0, screen_height - BOTTOMVIEW_HEIGHT, screen_width, BOTTOMVIEW_HEIGHT)];
        [_bottomView.playPause addTarget:self action:@selector(touchDownViewPlayerButton:) forControlEvents:UIControlEventTouchDown];
        [_bottomView.fastForward addTarget:self action:@selector(touchDownViewPlayerButton:) forControlEvents:UIControlEventTouchDown];
        [_bottomView.fastReverse addTarget:self action:@selector(touchDownViewPlayerButton:) forControlEvents:UIControlEventTouchDown];
        [_bottomView.nextVideo addTarget:self action:@selector(touchDownViewPlayerButton:) forControlEvents:UIControlEventTouchDown];
        [_bottomView.previousVideo addTarget:self action:@selector(touchDownViewPlayerButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _bottomView;
}

- (FYTopVideoPlayerView *)topView {
    if (!_topView) {
        _topView = [[FYTopVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, screen_width, TOPVIEW_HEIGHT)];
        [_topView.cancelPlayer addTarget:self action:@selector(touchDownViewPlayerButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _topView;
}

#pragma mark -setup NavogationController|statusBar|interfaceorientation

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}


@end
