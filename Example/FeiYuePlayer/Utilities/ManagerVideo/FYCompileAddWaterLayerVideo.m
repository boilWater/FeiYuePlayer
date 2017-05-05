//
//  FYCompileAddWaterLayerVideo.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/5.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCompileAddWaterLayerVideo.h"

@implementation FYCompileAddWaterLayerVideo

- (void)performWithAsset:(AVAsset *)asset completion:(FYCompileVideoCompletion)completion {
    if (!asset) {
        NSError *error = [NSError errorWithDomain:@"error:asset is blank" code:10241 userInfo:nil];
        completion(nil, nil, error);
        return;
    }
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    if (0 != [[asset tracksWithMediaType:AVMediaTypeVideo] count]) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if (0 != [[asset tracksWithMediaType:AVMediaTypeAudio] count]) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertCMTime = kCMTimeZero;
    NSError *error = nil;
    
    if (!self.mutableComposition) {
        self.mutableComposition = [AVMutableComposition composition];
        
        if (nil != assetVideoTrack) {
            AVMutableCompositionTrack *mutableVideoCompositionTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [mutableVideoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertCMTime error:&error];
        }
        if (nil != assetAudioTrack) {
            AVMutableCompositionTrack *mutableAudioCompositionTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [mutableAudioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertCMTime error:&error];
        }
    }
    
    if (0 != [[self.mutableComposition tracksWithMediaType:AVMediaTypeVideo] count]) {
        if (nil != self.mutableVideoComposition) {
            self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
            self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
            self.mutableVideoComposition.renderSize = assetVideoTrack.naturalSize;
            
//            AVMutableVideoCompositionInstruction *
        }
    }
}

@end
