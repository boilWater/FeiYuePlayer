//
//  FYRotateVideo.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/2.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^SLRotateVideoComplation) (id failure, id sueccess);

extern NSString * const FYRotateVideoSavedNew;

@interface FYRotateVideo : NSObject

@property(nonatomic, strong) AVMutableComposition *mutableComposition;
@property(nonatomic, strong) AVMutableVideoComposition *mutableVideoComposition;

- (void)rotateVideoWithURL:(NSURL *)url degreeOfAngle:(CGFloat)angle complation:(SLRotateVideoComplation)rotateVideoComplation;

@end
