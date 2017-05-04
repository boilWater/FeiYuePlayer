//
//  FYCompileEditVideo.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/4.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCompileEditVideo.h"

@implementation FYCompileEditVideo

- (void)performWithAsset:(AVAsset *)asset completion:(FYCompileVideoCompletion)completion {
    if (!asset) {
        NSError *error = [NSError errorWithDomain:@"error:asset is blank" code:10241 userInfo:nil];
        completion(nil, nil, error);
        return;
    }
    
    AVAssetTrack *videoAssetTrack = nil;
    AVAssetTrack *audioAssetTrack = nil;
    
    if (0 != [[asset tracksWithMediaType:AVMediaTypeVideo] count]) {
        videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if (0 != [[asset tracksWithMediaType:AVMediaTypeAudio] count]) {
        audioAssetTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertPoint = kCMTimeZero;
    NSError *error = nil;
    
    CMTime startTime = CMTimeMakeWithSeconds(_cMTimeRange.location, 1);
    CMTime durationTime = CMTimeMakeWithSeconds(_cMTimeRange.length, 1);
    
    if (!self.mutableComposition) {
        self.mutableComposition = [AVMutableComposition composition];
        
        if (nil != videoAssetTrack) {
            AVMutableCompositionTrack *mutableVideoCompositionTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            BOOL insertVideo = [mutableVideoCompositionTrack insertTimeRange:CMTimeRangeMake(startTime, durationTime) ofTrack:videoAssetTrack atTime:insertPoint error:&error];
            if (!insertVideo) {
                NSError *error = [NSError errorWithDomain:@"error:insert video is wrong" code:10241 userInfo:nil];
                completion(nil, nil, error);
            }else {
                completion(nil, nil, nil);
            }
        }
        if (nil != audioAssetTrack) {
            AVMutableCompositionTrack *mutableAudioCompositionTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            BOOL insertAudio = [mutableAudioCompositionTrack insertTimeRange:CMTimeRangeMake(startTime, durationTime) ofTrack:mutableAudioCompositionTrack atTime:insertPoint error:&error];
            if (!insertAudio) {
                NSError *error = [NSError errorWithDomain:@"error:insert audio is wrong" code:10241 userInfo:nil];
                completion(nil, nil, error);
            }else {
                completion(nil, nil, nil);
            }
        }
    }else {
        [self.mutableComposition removeTimeRange:CMTimeRangeMake(kCMTimeZero, startTime)];
        [self.mutableComposition removeTimeRange:CMTimeRangeMake(durationTime, [self.mutableComposition duration])];
    }
    
    completion(nil, self, nil);
    
    //post notification
//    [[NSNotificationCenter defaultCenter] postNotificationName:FYCompileVideoEditCompletionNotification object:self];
}

@end
