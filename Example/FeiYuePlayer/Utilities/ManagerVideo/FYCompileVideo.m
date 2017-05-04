//
//  FYCompileVideo.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/4.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCompileVideo.h"

NSString * const FYCompileVideoEditCompletionNotification = @"FYCompileVideoEditCompletionNotification";
NSString * const FYCompileVideoSavedCompletionNotification = @"FYCompileVideoSavedComletionNotification";

@implementation FYCompileVideo

- (instancetype)initWithComposition:(AVMutableComposition *)composition videoCompoition:(AVMutableVideoComposition *)videoComposition audioComposition:(AVMutableAudioMix *)audioMix {
    self = [super init];
    if (self) {
        self.mutableComposition = composition;
        self.mutableVideoCompoition = videoComposition;
        self.mutableAudioMix = audioMix;
    }
    return self;
}

- (void)performWithAsset:(AVAsset *)asset completion:(FYCompileVideoCompletion)completion{
    [self doesNotRecognizeSelector:_cmd];
}

@end
