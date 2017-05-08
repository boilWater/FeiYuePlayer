//
//  FYEditorPlayerViewController.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/27.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYEditorPlayerViewController.h"
#import "FeiYuePlayer-Prefix.pch"
#import "FYCompileEditVideo.h"
#import "FYCompileRotateVideo.h"
#import "FYCompileAddWaterLayerVideo.h"


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
@property(nonatomic, strong) UIButton *addWaterVideo;

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
    [self.view addSubview:self.addWaterVideo];
    
    [self initlizerPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUrlOfRotateVideo:) name:FYCompileVideoEditCompletionNotification object:nil];
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
        [self.mPlayerView setMPlayer:self.mPlayer];
    }
    [self.startPlayer addTarget:self action:@selector(startPlayerVideo:) forControlEvents:UIControlEventTouchDown];
    [self addObserver:self forKeyPath:@"mPlayerItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:playerItemStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rePlayVideoWithPlayItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == playerItemStatusContext) {
        
    }
}

- (void)getUrlOfRotateVideo:(NSNotification *)notification {
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

- (void)clickEditorView:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            _mCompileVideo = [[FYCompileEditVideo alloc] init];
            [_mCompileVideo performWithAsset:[AVAsset assetWithURL:self.urlSelectedVideo] completion:^(id failture, id success, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:[success mutableComposition]];
                    self.mPlayerItem.videoComposition = [success mutableVideoComposition];
                    [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
                    [self.mPlayerView setMPlayer:self.mPlayer];
                    
                });
                
            }];
            break;
        }
        case 1:
        {
            FYCompileRotateVideo *compileRotateVideo = [[FYCompileRotateVideo alloc] init];
            compileRotateVideo.angle = 90.0;
            [compileRotateVideo performWithAsset:[AVAsset assetWithURL:self.urlSelectedVideo] completion:^(id failture, id success, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:[success mutableComposition]];
                    self.mPlayerItem.videoComposition = [success mutableVideoComposition];
                    [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
                    [self.mPlayerView setMPlayer:self.mPlayer];
                    [self.mPlayerView setNeedsLayout];
                });
                
            }];
             
            break;
        }
        case 2:
        {
            FYCompileAddWaterLayerVideo *compileRotateVideo = [[FYCompileAddWaterLayerVideo alloc] init];
//            compileRotateVideo.angle = 90.0;
            [compileRotateVideo performWithAsset:[AVAsset assetWithURL:self.urlSelectedVideo] completion:^(id failture, id success, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:[success mutableComposition]];
                    self.mPlayerItem.videoComposition = [success mutableVideoComposition];
                    [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
                    [self.mPlayerView setMPlayer:self.mPlayer];
                    
                    if ([success compileLayer]) {
                        CALayer *waterLayer = [success compileLayer];
                        waterLayer.position = CGPointMake(self.mPlayerView.bounds.size.width/2, self.mPlayerView.bounds.size.height/2);
                        [[self.mPlayerView layer] insertSublayer:waterLayer above:(CALayer *)self.mPlayer];
                    }
                });
                
            }];
            
            break;
        }
        default:
            break;
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

#pragma mark - getter & setter

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
        [_rotateVideo setTitle:@"旋转" forState:UIControlStateNormal];
        [_rotateVideo setBackgroundColor:[UIColor blueColor]];
    }
    return _rotateVideo;
}

- (UIButton *)addWaterVideo {
    if (!_addWaterVideo) {
        CGFloat widthButton = 50;
        CGFloat positionY = SCREEN_HEIGHT - 50;
        CGFloat positionX = _rotateVideo.frame.origin.x + widthButton + 20;
        _addWaterVideo = [[UIButton alloc] initWithFrame:CGRectMake(positionX, positionY, widthButton, widthButton - 15)];
        _addWaterVideo.tag = 2;
        [_addWaterVideo addTarget:self action:@selector(clickEditorView:) forControlEvents:UIControlEventTouchDown];
        [_addWaterVideo setTitle:@"添加水印" forState:UIControlStateNormal];
        [_addWaterVideo setBackgroundColor:[UIColor blueColor]];
    }
    return _addWaterVideo;
}

@end
