//
//  FYCompileVideo.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/4.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString * const FYCompileVideoEditCompletionNotification;
extern NSString * const FYCompileVideoSavedCompletionNotification;

typedef void(^FYCompileVideoCompletion) (id failture, id success, NSError *error);

@interface FYCompileVideo : NSObject

@property(nonatomic, strong) AVMutableComposition *mutableComposition;
@property(nonatomic, strong) AVMutableVideoComposition *mutableVideoComposition;
@property(nonatomic, strong) AVMutableAudioMix *mutableAudioMix;
@property(nonatomic, strong) CALayer *compileLayer;

- (instancetype)initWithComposition:(AVMutableComposition *)composition videoCompoition:(AVMutableVideoComposition *)videoComposition audioComposition:(AVMutableAudioMix *)audioMix;

- (void)performWithAsset:(AVAsset *)asset completion:(FYCompileVideoCompletion)completion;

@end
