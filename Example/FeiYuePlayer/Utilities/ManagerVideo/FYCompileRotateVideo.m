//
//  FYCompileRotateVideo.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/5.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCompileRotateVideo.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@implementation FYCompileRotateVideo

- (void)performWithAsset:(AVAsset *)asset completion:(FYCompileVideoCompletion)completion {
    AVMutableVideoCompositionInstruction *mutableVideoCompositionInstruction = nil;
    AVMutableVideoCompositionLayerInstruction *mutableVideoCompositionLayerInstruction = nil;
    CGAffineTransform transform1;
    CGAffineTransform transform2;
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    if (0 != [[asset tracksWithMediaType:AVMediaTypeVideo] count]) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if (0 != [[asset tracksWithMediaType:AVMediaTypeAudio] count]) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertPoint = kCMTimeZero;
    NSError *error = nil;
    
    if (!self.mutableComposition) {
        self.mutableComposition = [AVMutableComposition composition];
        
        AVMutableCompositionTrack *mutableVideoCompositionTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [mutableVideoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetVideoTrack atTime:insertPoint error:&error];
        AVMutableCompositionTrack *mutableAudioCompositionTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [mutableAudioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetAudioTrack atTime:insertPoint error:&error];
    }
    
    CGSize videoSize = CGSizeZero;
    videoSize = [[asset tracksWithMediaType:AVMediaTypeVideo][0] naturalSize];
    
    transform1 = CGAffineTransformMakeTranslation(videoSize.height, 0.0);
    transform2 = CGAffineTransformRotate(transform1, degreesToRadians(_angle));
    
    if (!self.mutableVideoComposition) {
        self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
        self.mutableVideoComposition.renderSize = CGSizeMake(videoSize.width, videoSize.height);
        self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
        
        mutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mutableVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
        
        mutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.mutableComposition.tracks[0]];
        [mutableVideoCompositionLayerInstruction setTransform:transform2 atTime:kCMTimeZero];
    }else {
        self.mutableVideoComposition.renderSize = CGSizeMake(self.mutableVideoComposition.renderSize.width, self.mutableVideoComposition.renderSize.height);
        
        mutableVideoCompositionInstruction = self.mutableVideoComposition.instructions[0];
        mutableVideoCompositionLayerInstruction = mutableVideoCompositionInstruction.layerInstructions[0];
        
        CGAffineTransform existingTransform;
        
        if (![mutableVideoCompositionLayerInstruction getTransformRampForTime:[self.mutableComposition duration] startTransform:&existingTransform endTransform:NULL timeRange:NULL]) {
            [mutableVideoCompositionLayerInstruction setTransform:transform2 atTime:kCMTimeZero];
        } else {
            CGAffineTransform transform3 = CGAffineTransformMakeTranslation(-1 *assetVideoTrack.naturalSize.height/2, 0.0);
            CGAffineTransform newTransform = CGAffineTransformConcat(existingTransform, CGAffineTransformConcat(transform2, transform3));
            [mutableVideoCompositionLayerInstruction setTransform:newTransform atTime:kCMTimeZero];
        }
    }
    
    mutableVideoCompositionInstruction.layerInstructions = @[mutableVideoCompositionLayerInstruction];
    self.mutableVideoComposition.instructions = @[mutableVideoCompositionInstruction];
    
    completion(nil, self, nil);
}

@end
