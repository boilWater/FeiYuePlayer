//
//  FYEditorViewController.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/4/27.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYEditorViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FeiYuePlayer-Prefix.pch"
#import "FYEditorPlayerViewController.h"
#import "FYCustomButton.h"

@interface FYEditorViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) FYCustomButton *selectVideo;
@property(nonatomic, strong) FYCustomButton *editorVideo;
@property(nonatomic, copy) NSURL *urlSelectedVideo;

@end

@implementation FYEditorViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlizerCustomParamter];
    
    [self.view addSubview:self.selectVideo];
    [self.view addSubview:self.editorVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - privatedMethod(initlizerCustomParamter)

- (void)initlizerCustomParamter {
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - privatedMethod(clickButtonEvents)

- (void)clickSelectVideo {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(__bridge NSString *)kUTTypeMovie, (__bridge NSString *)kUTTypeVideo, nil];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing  = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)clickEditorVideo {
    FYEditorPlayerViewController *editorViewController = [[FYEditorPlayerViewController alloc] init];
    
    _urlSelectedVideo = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"]];
    
    editorViewController.urlSelectedVideo = _urlSelectedVideo;
    [self.navigationController pushViewController:editorViewController animated:YES];
}

#pragma mark - UIImagePickerViewControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (info) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        if (url) {
            _urlSelectedVideo = url;
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter & getter

- (FYCustomButton *)selectVideo {
    if (!_selectVideo) {
        _selectVideo = [[FYCustomButton alloc] init];
        CGFloat width = 120;
        _selectVideo.frame = CGRectMake((SCREEN_WIDTH-width)/2, 80, width, 45);
        [_selectVideo addTarget:self action:@selector(clickSelectVideo) forControlEvents:UIControlEventTouchDown];
        [_selectVideo setTitle:@"选择视频" forState:UIControlStateNormal];
    }
    return _selectVideo;
}

- (FYCustomButton *)editorVideo {
    if (!_editorVideo) {
        _editorVideo = [[FYCustomButton alloc] init];
        CGFloat width = 100;
        CGFloat positionX = 20;
        CGFloat positionY = self.selectVideo.frame.origin.y + 75;
        _editorVideo.frame = CGRectMake(positionX, positionY, width, 40);
        [_editorVideo addTarget:self action:@selector(clickEditorVideo) forControlEvents:UIControlEventTouchDown];
        [_editorVideo setTitle:@"剪切视频" forState:UIControlStateNormal];
        [_editorVideo setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    }
    return _editorVideo;
}

@end
