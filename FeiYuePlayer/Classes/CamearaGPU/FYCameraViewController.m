//
//  FYCameraViewController.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/13.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCameraViewController.h"
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Content-PrefixHeader.pch"

#define WIDTH_TAKEPHOTO_BUTTON (120)
#define HEIGHT_TAKEPHOTO_BUTTON (40)

@interface FYCameraViewController ()

@property(nonatomic, strong) GPUImageStillCamera *mImageStillCamera;
@property(nonatomic, strong) GPUImageFilter *mImageFilter;
@property(nonatomic, strong) GPUImageView *mImageView;
@property(nonatomic, strong) UIButton *mTakePhotoButton;

@end

@implementation FYCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"照相机";
    [self.mImageStillCamera addTarget:self.mImageFilter];
    [self.mImageFilter addTarget:self.mImageView];
    [self.view addSubview:self.mImageView];
    [self.view addSubview:self.mTakePhotoButton];
    
    [self.mImageStillCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark -private Method

- (void)takePhoto{
    [self.mImageStillCamera capturePhotoAsPNGProcessedUpToFilter:self.mImageFilter
                                           withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeImageDataToSavedPhotosAlbum:processedPNG
                                               metadata:self.mImageStillCamera.currentCaptureMetadata
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error){
                NSLog(@"ERROR: error is %@", error);
            }else {
                NSLog(@"SUCCESS: save URL > %@", assetURL);
            }
        }];
    }];
}

#pragma mark -setter & getter

- (GPUImageStillCamera *)mImageStillCamera {
    if (!_mImageStillCamera) {
        _mImageStillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset352x288 cameraPosition:AVCaptureDevicePositionBack];
        _mImageStillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _mImageStillCamera;
}

- (GPUImageFilter *)mImageFilter {
    if (!_mImageFilter) {
        _mImageFilter = [[GPUImageToonFilter alloc] init];
    }
    return _mImageFilter;
}

- (GPUImageView *)mImageView {
    if (!_mImageView) {
        _mImageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    }
    return _mImageView;
}

- (UIButton *)mTakePhotoButton {
    if (!_mTakePhotoButton) {
        _mTakePhotoButton = [[UIButton alloc] init];
        _mTakePhotoButton.frame = CGRectMake((SCREEN_WIDTH-WIDTH_TAKEPHOTO_BUTTON)/2, SCREEN_HEIGHT - 60, WIDTH_TAKEPHOTO_BUTTON, HEIGHT_TAKEPHOTO_BUTTON);
        [_mTakePhotoButton setTitle:@"takePhoto" forState:UIControlStateNormal];
        [_mTakePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mTakePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _mTakePhotoButton.backgroundColor = [UIColor orangeColor];
        [_mTakePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchDown];
    }
    return _mTakePhotoButton;
}

@end
