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
    self.compileLayer = nil;
    CGSize videoSize;

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
        if (!self.mutableVideoComposition) {
            self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
            self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
            self.mutableVideoComposition.renderSize = assetVideoTrack.naturalSize;
            
            AVMutableVideoCompositionInstruction *videoCompositonInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            videoCompositonInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
            
            AVAssetTrack *videoTrack = [self.mutableComposition tracksWithMediaType:AVMediaTypeVideo][0];
            AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstructionInternal = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            videoCompositonInstruction.layerInstructions = @[videoCompositionLayerInstructionInternal];
            self.mutableVideoComposition.instructions = @[videoCompositonInstruction];
        }
        videoSize = self.mutableVideoComposition.renderSize;
        self.compileLayer = [self watermarkLayerForSize:videoSize];
    }
    completion(nil, self, nil);
//    [[NSNotificationCenter defaultCenter] postNotificationName:FYCompileVideoEditCompletionNotification object:self];
}

- (CALayer*)watermarkLayerForSize:(CGSize)videoSize
{
    CALayer *_watermarkLayer = [CALayer layer];
    
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = @"菲悦科技";
    titleLayer.foregroundColor = [[UIColor redColor] CGColor];
    titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.bounds = CGRectMake(0, 0, videoSize.width/2, videoSize.height/2);
    
    [_watermarkLayer addSublayer:titleLayer];
    
    return _watermarkLayer;
}

@end
