//
//  FYEditorPlayerViewController.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/27.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYEditorPlayerViewController.h"
#import "FeiYuePlayer-Prefix.pch"
//#import "SLEditorVideo.h"
//#import "FYRotateVideo.h"
#import "FYCompileEditVideo.h"

static void *playerItemStatusContext = &playerItemStatusContext;

@interface FYEditorPlayerViewController ()<UIAlertViewDelegate>{
    CGFloat startCMTime;
    CGFloat endCMTime;
}

@property(nonatomic, strong) AVPlayer *mPlayer;
@property(nonatomic, strong) AVPlayerItem *mPlayerItem;
@property(nonatomic, strong) FYCompileVideo *mCompileVideo;
@property(nonatomic, strong) UISlider *startSlider;
@property(nonatomic, strong) UISlider *endSlider;
@property(nonatomic, strong) UIButton *editorVideo;
@property(nonatomic, strong) UIButton *rotateVideo;

@property(nonatomic, strong) NSURL *rotateURL;

@end

@implementation FYEditorPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlizerCustomParamter];
    
    [self.view addSubview:self.startSlider];
    [self.view addSubview:self.endSlider];
    [self.view addSubview:self.editorVideo];
    [self.view addSubview:self.rotateVideo];
    
    [self initlizerPlayer];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUrlOfRotateVideo:) name:FYRotateVideoSavedNew object:nil];
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

#pragma mark - privatedMethod(initlizerCustomParamter)

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

#pragma mark - privatedMethod(ClickMethod)

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
    if (slider.tag == 1) {
        startCMTime = slider.value;
    }else if (slider.tag == 2){
        endCMTime = slider.value;
    }
}

#pragma mark - UIAlertViewDelegate

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

- (UIButton *)editorVideo {
    if (!_editorVideo) {
        CGFloat widthButton = 50;
        CGFloat positionY = SCREEN_HEIGHT - 50;
        CGFloat positionX = widthButton;
        _editorVideo = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, widthButton, widthButton - 15)];
        _editorVideo.tag = 0;
        [_editorVideo addTarget:self action:@selector(clickEditorView:) forControlEvents:UIControlEventTouchDown];
        [_editorVideo setTitle:@"剪切" forState:UIControlStateNormal];
        [_editorVideo setBackgroundColor:[UIColor blueColor]];
    }
    return _editorVideo;
}

- (UIButton *)rotateVideo {
    if (!_rotateVideo) {
        CGFloat widthButton = 50;
        CGFloat positionY = SCREEN_HEIGHT - 50;
        CGFloat positionX = _editorVideo.frame.origin.x + widthButton + 20;
        _rotateVideo = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, widthButton, widthButton - 15)];
        _rotateVideo.tag = 1;
        [_rotateVideo addTarget:self action:@selector(clickEditorView:) forControlEvents:UIControlEventTouchDown];
        [_rotateVideo setTitle:@"剪切" forState:UIControlStateNormal];
        [_rotateVideo setBackgroundColor:[UIColor blueColor]];
    }
    return _rotateVideo;
}

- (void)clickEditorView:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            /*
            AVAsset *asset = [AVAsset assetWithURL:self.urlSelectedVideo];
            double totalVideo = CMTimeGetSeconds([asset duration]);
            startCMTime = MIN(startCMTime, endCMTime);
            endCMTime = MAX(startCMTime, endCMTime);
            
            NSRange range = NSMakeRange(startCMTime * totalVideo, (endCMTime - startCMTime) * totalVideo);
            //视频进行剪切
            [[SLEditotVideo shareInstance] editorVideoWithURL:self.urlSelectedVideo videoRange:range completion:^(id failure, id success) {
                
            }];
             */
            _mCompileVideo = [[FYCompileEditVideo alloc] init];
            [_mCompileVideo performWithAsset:[AVAsset assetWithURL:self.urlSelectedVideo] completion:^(id failture, id success, NSError *error) {
                self.mPlayerItem = [AVPlayerItem playerItemWithAsset:[success mutableComposition]];
                self.mPlayer = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
                [self.mPlayerView setMBasePlayer:self.mPlayer];
            }];
            break;
        }
        case 1:
        {
            
            break;
        }
        default:
            break;
    }
}

@end
