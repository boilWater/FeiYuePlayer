//
//  SLEditotVideo.m
//  PROJECT
//
//  Created by liangbai on 2017/4/27.
//  Copyright © 2017年 PROJECT_OWNER. All rights reserved.
//

#import "SLEditorVideo.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SLEditotVideo ()

@property(nonatomic, strong) AVMutableComposition *composition;

@end

@implementation SLEditotVideo

+ (instancetype)shareInstance {
    static SLEditotVideo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SLEditotVideo alloc] init];
    });
    return instance;
}

#pragma mark -
#pragma mark -privatedMethod()

- (void)editorVideoWithURL:(NSURL *)url videoRange:(NSRange)videoRange completion:(SLEditorVideoCompletion)editorVideoCompletion {
    if (!url) {
        editorVideoCompletion(@"error:视频资源为空", nil);
    }
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    if (0 != [[asset tracksWithMediaType:AVMediaTypeVideo] count]) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if (0 != [[asset tracksWithMediaType:AVMediaTypeAudio] count]) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;
    
    //    double halfDuration = CMTimeGetSeconds([asset duration])/2.0;
    //    CMTime trimmedDuration = CMTimeMakeWithSeconds(halfDuration, asset.duration.timescale);
    
    CMTime startCMTime  = CMTimeMakeWithSeconds(videoRange.location, asset.duration.timescale);
    CMTime durationCMTime = CMTimeMakeWithSeconds(videoRange.length, asset.duration.timescale);
    
    if (self.composition) {
        if(assetVideoTrack != nil) {
            AVMutableCompositionTrack *compositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(startCMTime, durationCMTime) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
        }
        if(assetAudioTrack != nil) {
            AVMutableCompositionTrack *compositionAudioTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(startCMTime, durationCMTime) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
        }
    }
    
    AVAssetExportSession *exporteSession = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:AVAssetExportPresetHighestQuality];
    exporteSession.outputURL= [self getURLSavedEditorVideo];;
    exporteSession.outputFileType = AVFileTypeQuickTimeMovie;
    exporteSession.shouldOptimizeForNetworkUse = YES;
    [exporteSession exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:exporteSession];
         });
     }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    if(session.status == AVAssetExportSessionStatusCompleted){
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    [self showToastViewWithMessage:@"error"];
                                                }else{
                                                    [self showToastViewWithMessage:@"Video Save"];
                                                }
                                                
                                            });
                                            
                                        }];
        }
    }
}

#pragma mark -
#pragma mark -privatedMethod()

- (NSURL *)getURLSavedEditorVideo {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *stringSavedEditorVideo = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"slEditorVideo-%d.mov", arc4random() % 1000]];
    NSURL *urlSavedEditorVideo = [NSURL fileURLWithPath:stringSavedEditorVideo];
    return urlSavedEditorVideo;
}

- (void)showToastViewWithMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark -
#pragma mark -setter & getter

- (AVMutableComposition *)composition {
    if (!_composition) {
        _composition = [AVMutableComposition composition];
    }
    return _composition;
}

@end
