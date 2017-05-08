//
//  SLAVPlayerViewController.h
//  PROJECT
//
//  Created by liangbai on 2017/4/26.
//  Copyright © 2017年 PROJECT_OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SLPlayerView : UIView

@property(nonatomic, strong) AVPlayer *mPlayer;

@end

@interface SLAVPlayerViewController : UIViewController

@property(nonatomic, copy) NSURL *urlSelectedVideo;
@property(nonatomic, strong) SLPlayerView *mPlayerView;
@property(nonatomic, strong) UIButton *startPlayer;

@end
