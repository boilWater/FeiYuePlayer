//
//  FYVideoPlayerViewController.h
//  Pods
//
//  Created by liangbai on 2017/4/17.
//
//

#import <UIKit/UIKit.h>

@interface FYVideoPlayerViewController : UIViewController

@property(nonatomic, strong) NSString *titleVideoPlayer;

- (instancetype)initWithVideoUrl:(NSURL *)url;

@end
