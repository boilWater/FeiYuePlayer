//
//  FYShowViewController.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/26.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYShowViewController.h"
#import <GPUImage/GPUImageView.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FYCustomButton.h"
#import "FeiYuePlayer-Prefix.pch"
#import "FYImagePickerController.h"
#import "FYVideoPlayerViewController.h"
#import "UIImage+FYImage.h"

#define BUTTON_WIDTH (120)
#define BUTTON_HEIGHT (55)

@interface FYShowViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
}

@property(nonatomic, strong) UIButton *videoPlayer;
@property(nonatomic, strong) UIButton *videoProcessing;
@property(nonatomic, strong) NSURL *selectVideoUrl;

@end

@implementation FYShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHierarchy];
    [self.view addSubview:self.videoPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -initHierarchy

- (void)initHierarchy {
    self.title = @"播放器";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark -setter & getter

- (UIButton *)videoPlayer {
    if (!_videoPlayer) {
        CGRect rect = CGRectMake((SCREEN_WIDTH - BUTTON_WIDTH)/2, 100, BUTTON_WIDTH, BUTTON_HEIGHT);
        _videoPlayer = [[FYCustomButton alloc] initWithFrame:rect];
        [_videoPlayer setTitle:@"选着视频" forState:UIControlStateNormal] ;
        [_videoPlayer addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _videoPlayer;
}

#pragma mark -UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _selectVideoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (nil != _selectVideoUrl) {
        [_videoPlayer setTitle:@"视频播放" forState:UIControlStateNormal];
        [_videoPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_videoPlayer setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    }
}

#pragma mark -privateMethod

- (void)clickButton:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"选着视频"]) {
        FYImagePickerController *imagePickerController = [[FYImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(__bridge NSString *)kUTTypeMovie, (__bridge NSString *)kUTTypeVideo, nil];
        imagePickerController.allowsEditing = NO;
        imagePickerController.delegate = self;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"视频播放"]) {
        //        NSURL *tempUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
        FYVideoPlayerViewController *videoPlayerViewController = [[FYVideoPlayerViewController alloc] initWithVideoUrl:_selectVideoUrl];
        videoPlayerViewController.titleVideoPlayer = @"老男孩";
        [self presentViewController:videoPlayerViewController animated:YES completion:nil];
    }
}

@end
