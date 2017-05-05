//
//  FYRotateVideo.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/2.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYRotateVideo.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define degreeToRadians(radians) ((radians) / (180*M_PI))

@interface FYRotateVideo ()
//
//@property(nonatomic, strong) AVMutableComposition *mutableComposition;
//@property(nonatomic, strong) AVMutableVideoComposition *mutableVideoComposition;

@end

NSString * const FYRotateVideoSavedNew = @"FYRotateVideoSavedNew";

@implementation FYRotateVideo

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - privatedMethod()


- (void)rotateVideoWithURL:(NSURL *)url degreeOfAngle:(CGFloat)angle complation:(SLRotateVideoComplation)rotateVideoComplation {
    AVMutableVideoCompositionInstruction *mutableVideoCompositionInstruction = nil;
    AVMutableVideoCompositionLayerInstruction *mutableVideoCompositionLayerInstruction = nil;
    CGAffineTransform transform1;
    CGAffineTransform transform2;
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
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
    transform2 = CGAffineTransformRotate(transform1, degreeToRadians(angle));
    
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:FYRotateVideoSavedNew object:self];
  
    rotateVideoComplation(nil, self);
    
    AVAssetExportSession *exporteSession = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition presetName:AVAssetExportPresetHighestQuality];
    exporteSession.outputURL= [self getURLSavedEditorVideo];;
    exporteSession.outputFileType = AVFileTypeQuickTimeMovie;
    exporteSession.shouldOptimizeForNetworkUse = YES;
    [exporteSession exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:exporteSession completion:^(id failure, id success) {
//                 rotateVideoComplation(failure, success);
             }];
         });
     }];
   
}

- (void)exportDidFinish:(AVAssetExportSession*)session completion:(void (^)(id failure, id success)) completion {
    if(session.status == AVAssetExportSessionStatusCompleted){
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    completion(error, nil);
                                                    [self showToastViewWithMessage:@"error"];
                                                }else{
                                                    completion(nil, outputURL);
                                                    [self showToastViewWithMessage:@"Video Save"];
//                                                    [[NSNotificationCenter defaultCenter] postNotificationName:FYRotateVideoSavedNewUrl object:outputURL];
                                                }
                                            });
                                            
                                        }];
        }
    }
}

#pragma mark - privatedMethod()

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

@end
