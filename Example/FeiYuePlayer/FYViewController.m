//
//  FYViewController.m
//  FeiYuePlayer
//
//  Created by boilwater on 04/12/2017.
//  Copyright (c) 2017 boilwater. All rights reserved.
//

#import "FYViewController.h"
#import <GPUImage/GPUImageView.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FYCustomButton.h"
#import "FeiYuePlayer-Prefix.pch"
#import "FYImagePickerController.h"

#define BUTTON_WIDTH (120)
#define BUTTON_HEIGHT (55)

@interface FYViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
//    GPUImageView *
}

@property(nonatomic, strong) UIButton *videoPlayer;
@property(nonatomic, strong) UIButton *videoProcessing;

@end

@implementation FYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHierarchy];
    [self.view addSubview:self.videoPlayer];
}

#pragma mark -initHierarchy

- (void)initHierarchy {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark -setter & getter

- (UIButton *)videoPlayer {
    if (!_videoPlayer) {
        CGRect rect = CGRectMake((SCREEN_WIDTH - BUTTON_WIDTH)/2, 100, BUTTON_WIDTH, BUTTON_HEIGHT);
        _videoPlayer = [[FYCustomButton alloc] initWithFrame:rect];
        [_videoPlayer setTitle:@"视频播放" forState:UIControlStateNormal] ;
        [_videoPlayer addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _videoPlayer;
}

#pragma mark -UIImagePickerControllerDelegate 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSURL *urlVideo = [info objectForKey:UIImagePickerControllerMediaURL];
    
}

#pragma mark -privateMethod

- (void)clickButton:(UIButton *)sender {
    FYImagePickerController *imagePickerController = [[FYImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(__bridge NSString *)kUTTypeMovie, (__bridge NSString *)kUTTypeVideo, nil];
    imagePickerController.allowsEditing = NO;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
