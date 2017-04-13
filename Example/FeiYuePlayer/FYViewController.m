//
//  FYViewController.m
//  FeiYuePlayer
//
//  Created by boilwater on 04/12/2017.
//  Copyright (c) 2017 boilwater. All rights reserved.
//

#import "FYViewController.h"
#import <GPUImage/GPUImageView.h>

@interface FYViewController (){
//    GPUImageView *
}

@end

@implementation FYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHierarchy];
}

#pragma mark -initHierarchy

- (void)initHierarchy {
    self.title = @"飞跃Player";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
