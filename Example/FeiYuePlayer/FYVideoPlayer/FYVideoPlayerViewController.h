//
//  FYVideoPlayerViewController.h
//  Pods
//
//  Created by liangbai on 2017/4/17.
//
//

#import <UIKit/UIKit.h>

@class FYMediaModel;

@interface FYVideoPlayerViewController : UIViewController

@property(nonatomic, strong) NSString *kTitle;

- (instancetype)initWithVideoUrl:(NSURL *)kURL;

- (instancetype)initWithMediaModel:(FYMediaModel *)kMediaModel;

@end
