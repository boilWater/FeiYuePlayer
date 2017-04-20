//
//  FYVideoPlayerViewController.m
//  Pods
//
//  Created by liangbai on 2017/4/17.
//
//

#import "FYVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FYBottomVideoPlayerView.h"
#import "FYTopVideoPlayerView.h"
#import "FeiYuePlayer-Prefix.pch"

@interface FYPlayerView : UIView

@property(nonatomic, strong) AVPlayer *mPlayer;

@end

@implementation FYPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)MPlayer {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setMPlayer:(AVPlayer *)avPlayer {
    [(AVPlayerLayer *)[self layer] setPlayer:avPlayer];
}

- (void)dealloc {
    self.mPlayer = nil;
}

@end

#pragma mark -

static void * playerItemDurationContext = &playerItemDurationContext;
static void * playerItemStatusContext = &playerItemStatusContext;
static void * playerPlayingContext = &playerPlayingContext;

#define BOTTOMVIEW_HEIGHT (75)
#define TOPVIEW_HEIGHT (44)

@interface FYVideoPlayerViewController () {
    CGFloat screen_width;
    CGFloat screen_height;
    
    CGFloat screenBrightness;//brightness of screen
    CGFloat systemVolume;//volume of system
    CGFloat playingProcess;//precess of playing video
    
    UISlider *systemVolumeSlider;//slider changing volume of system
    
    CGFloat currentTouchPositionX;//current position x touched
    CGFloat currentTouchPositionY;//current position x touched
    
    CGFloat offsetX;//relative displacement in x two touchs
    CGFloat offsetY;//relative displacement in y two touchs
}

@property(nonatomic, strong) FYPlayerView *playerView;

@property(nonatomic, strong) AVPlayer *mPlayer;//player
@property(nonatomic, strong) AVPlayerItem *mPlayerItem;
@property(nonatomic, copy) NSURL *mVideoURL;//url of video 

@property(nonatomic, assign) BOOL mPlaying; //is Playing or Not
@property(nonatomic, assign) BOOL mReplayed;//is Replay or Not

@property(nonatomic, assign) CMTime totalTimeVideo;//total time of video

@property(nonatomic, strong) FYBottomVideoPlayerView *bottomView;
@property(nonatomic, strong) FYTopVideoPlayerView *topView;

@end

@implementation FYVideoPlayerViewController

- (instancetype)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        if (url) {
          self.mVideoURL = [url copy];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializerCustomParamter];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
    [self initializerVideoPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"mPlaying" context:playerPlayingContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [self removeObserver:self forKeyPath:@"mPlayerItem.status" context:playerItemStatusContext];
}

#pragma mark -
#pragma mark -privateMethod(initializer)

- (void)initializerCustomParamter {
    self.view.backgroundColor = [UIColor whiteColor];
    screen_width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    screen_height = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    self.topView.titleVideoPlayer = _titleVideoPlayer;
    
    //add KVO aboout mPlaying in order to change the background image of playPause button
    [self addObserver:self forKeyPath:@"mPlaying" options:NSKeyValueObservingOptionNew context:playerPlayingContext];
    
    //observe state of app: receive call, lock screen. And pause video playing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingVideoWithAppResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rePlayVideoWithAppDidBacomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initializerVideoPlayer {
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:self.mVideoURL options:nil];
    self.mPlayerItem = [[AVPlayerItem alloc] initWithAsset:urlAsset];
    
    [self addObserver:self forKeyPath:@"mPlayerItem.status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:playerItemStatusContext];
    //TODO add video finish playing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rePlayVideoWithPlayItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.mPlayer = [[AVPlayer alloc] initWithPlayerItem:self.mPlayerItem];
    
    [self.playerView setMPlayer:self.mPlayer];
    
    [self.playerView.layer setBackgroundColor:[UIColor blackColor].CGColor];
}

#pragma mark -privateMethod(clickButton)

- (void)touchDownViewPlayerButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0: //playPause
        {
            [self clickPlayPauseButton];
            break;
        }
        case 1: //fastForward
        {
            [self clickFastForwardButton];
            break;
        }
        case 2: //fastReverse
        {
            [self clickFastReverseButton];
            break;
        }
        case 3: //nextVideo
        {
            [self clickNextVideoButton];
            break;
        }
        case 4: //previousVideo
        {
            [self clickPreviousViewButton];
            break;
        }
        case 5: //return HomeView
        {
            [self dismissViewControllerToPreviousViewController];
            break;
        }
        default:
            break;
    }
}

- (void)clickPlayPauseButton {
    [self cancelPerformSelector:@selector(disAppearOnTopViewAndBottomViewWithDuration:)];
    if (!self.mPlaying) {
        [self.mPlayer play];
        
        self.mPlaying = YES;
    }else {
        [self.mPlayer pause];
        
        self.mPlaying = NO;
    }
    [self hideTopAndBottomViewWithDelayTime:0.0f];
}

- (void)clickFastForwardButton {
    
}

- (void)clickFastReverseButton {
    
}

- (void)clickNextVideoButton {
    
}

- (void)clickPreviousViewButton {
    
}

- (void)stopPlayingVideoWithAppResignActive {
    
}

- (void)rePlayVideoWithAppDidBacomeActive {
    
}

- (void)rePlayVideoWithPlayItemDidPlayToEndTime {
    [self.mPlayerItem seekToTime:kCMTimeZero];
    self.mPlaying = NO;
}

#pragma mark -
#pragma mark -prevatedMethod(Hierarchy)

- (void)disAppearOnTopViewAndBottomViewWithDuration:(NSTimeInterval)duration {
    if (0 == duration) {
        duration = 0.5f;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.topView setAlpha:0.0f];
        [self.bottomView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideTopAndBottomViewWithDelayTime:(CGFloat)delayTime {
    uint64_t delayInSeconds;
    if (0 == delayTime) {
        delayInSeconds = 5.0f;
    }else {
        delayInSeconds = delayTime;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self disAppearOnTopViewAndBottomViewWithDuration:0];
    });
}

- (void)appearOnTopViewAndBottomViewWithDuration:(NSTimeInterval)duration {
    if (0 == duration) {
        duration = 0.5f;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.topView setAlpha:0.5f];
        [self.bottomView setAlpha:0.5f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showTopAndBottomViewWithDelayTime:(CGFloat)delayTime {
    uint64_t delayInSeconds;
    if (0 == delayTime) {
        delayInSeconds = 1.5f;
    }else {
        delayInSeconds = delayTime;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self appearOnTopViewAndBottomViewWithDuration:0];
    });
}

- (void)cancelPerformSelector:(SEL)selector {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
}

#pragma mark -
#pragma mark -privatedMethod(dealWithParameters)

- (NSString *)stringWithCMTime:(CMTime)time {
    NSTimeInterval seconds = time.value/time.timescale;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [dateFormatter setDateFormat:(seconds/3600 > 1) ? @"h:mm:ss" : @"mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

#pragma mark -
#pragma mark -KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == playerItemStatusContext) {
        if (self.mPlayerItem.status == AVPlayerStatusReadyToPlay) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self isReadyToPlayVideo];
            });
        }else {
            NSLog(@"video can not play in class:%@", [self class]);
            [self performSelector:@selector(dismissViewControllerToPreviousViewController) withObject:nil afterDelay:3.0f];
        }
    }else if (context == playerPlayingContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1 == [[change objectForKey:@"new"] integerValue]) {
                [self.bottomView.playPause setImage:FYIMAGEWITHNAMED(@"pause_nor.png") forState:UIControlStateNormal];
            }else {
                [self.bottomView.playPause setImage:FYIMAGEWITHNAMED(@"play_nor.png") forState:UIControlStateNormal];
            }
        });
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -isReadyToPlayVideo

- (void)isReadyToPlayVideo {
    [self hideTopAndBottomViewWithDelayTime:4.0f];
    
    self.mReplayed = YES;
    self.bottomView.enabledAllButton = YES;//设置播放相关按钮可以点击
    
    self.totalTimeVideo = self.mPlayerItem.duration;
    //设置播放的剩余时间
    self.bottomView.textRemainTime = [NSString stringWithFormat:@"-%@", [self stringWithCMTime:self.totalTimeVideo]];
    __weak typeof(self) weakSelf = self;
    [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMake(3, 30) queue:nil usingBlock:^(CMTime time) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.bottomView.textCurrentTime = [strongSelf stringWithCMTime:time];
        
        NSString *remainTime = [strongSelf stringWithCMTime:CMTimeSubtract(strongSelf.totalTimeVideo, time)];
        strongSelf.bottomView.textRemainTime = remainTime;
        
        strongSelf.bottomView.valueCurrentProcess = CMTimeGetSeconds(time)/CMTimeGetSeconds(strongSelf.totalTimeVideo);
    }];
}

#pragma mark -dismissViewController

- (void)dismissViewControllerToPreviousViewController {
    if (self.mPlaying) {
        [self.mPlayer pause];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark -touches(overrided)

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    currentTouchPositionX = [touch locationInView:touch.view].x;
    currentTouchPositionY = [touch locationInView:touch.view].y;
    
    screenBrightness = [UIScreen mainScreen].brightness;
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            systemVolumeSlider = (UISlider *)view;
        }
    }
    
    systemVolume = systemVolumeSlider.value;
    
    if (0.0f == self.topView.alpha) {
        [self showTopAndBottomViewWithDelayTime:0.0f];
    }else {
        [self hideTopAndBottomViewWithDelayTime:0.0f];
        [self cancelPerformSelector:@selector(disAppearOnTopViewAndBottomViewWithDuration:)];
        
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (0.0 == self.topView.alpha) {
        
    }else {
        [self hideTopAndBottomViewWithDelayTime:0.0];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (0.0 == self.topView.alpha) {
        
    }else {
        [self hideTopAndBottomViewWithDelayTime:0.0];
    }
}

#pragma mark -
#pragma mark -setter & getter

- (FYPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[FYPlayerView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    }
    return _playerView;
}

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

#pragma mark -
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
