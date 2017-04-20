//
//  FYBottomVideoPlayerView.h
//  Pods
//
//  Created by liangbai on 2017/4/18.
//
//

#import <UIKit/UIKit.h>

@interface FYBottomVideoPlayerView : UIView

@property(nonatomic, strong) UIButton *playPause;
@property(nonatomic, strong) UIButton *fastForward;
@property(nonatomic, strong) UIButton *fastReverse;
@property(nonatomic, strong) UIButton *nextVideo;
@property(nonatomic, strong) UIButton *previousVideo;

@property(nonatomic, assign) BOOL enabledAllButton;
@property(nonatomic, strong) NSString *textRemainTime;
@property(nonatomic, strong) NSString *textCurrentTime;
@property(nonatomic, assign) float valueCurrentProcess;

@end
