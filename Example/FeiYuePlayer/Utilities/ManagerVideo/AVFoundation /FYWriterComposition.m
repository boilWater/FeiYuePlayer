//
//  FYWriterComposition.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYWriterComposition.h"
#import <AVFoundation/AVAssetWriterInput.h>
#import <AVFoundation/AVMediaFormat.h>
#import "FYAVAssetReaderOutput.h"

@interface FYWriterComposition ()

@property(nonatomic, strong) AVAssetWriter *kAssetWriter;
@property(nonatomic, strong) AVAssetReader *kAssetReader;
@property(nonatomic, strong) AVAssetWriterInput *kAudioAssetWriterInput;
@property(nonatomic, strong) AVAssetWriterInput *kVideoAssetWriterInput;
@property(nonatomic) dispatch_queue_t dispatch_audio_queue;
@property(nonatomic) dispatch_queue_t dispatch_video_queue;
@property(nonatomic) dispatch_group_t dispatch_group;

@end

@implementation FYWriterComposition

- (instancetype)initWriterCompositionWithAssetReader:(AVAssetReader *)assetReader assetWriter:(AVAssetWriter *)assetWriter {
    self = [super init];
    if (self) {
        self.kAssetReader = assetReader;
        self.kAssetWriter = assetWriter;
        NSString *audioCharDispatch = [NSString stringWithFormat:@"%@.audioIsolation.%p", [self class], self];
        self.dispatch_audio_queue = dispatch_queue_create([audioCharDispatch UTF8String], DISPATCH_QUEUE_SERIAL);
        NSString *videoCharDispatch = [NSString stringWithFormat:@"%@.videoIsolation.%p", [self class], self];
        self.dispatch_video_queue = dispatch_queue_create([videoCharDispatch UTF8String], DISPATCH_QUEUE_SERIAL);
        self.dispatch_group = dispatch_group_create();
    }
    return self;
}

- (void)start {
    BOOL success = YES;
    NSError *outPutError = nil;
    success = [self.kAssetReader startReading];
    if (!success) {
        outPutError = self.kAssetReader.error;
    }
    if (success) {
        success = [self.kAssetWriter startWriting];
        if (!success) {
            outPutError = self.kAssetWriter.error;
        }
    }
    if (success) {
        //设置开始读取的时间
        [self.kAssetWriter startSessionAtSourceTime:kCMTimeZero];
        
        self.kAudioAssetWriterInput = [self assetWriterInputWithMediaType:AVMediaTypeAudio];
        AVAssetReaderOutput *assetReaderAudioMixOutput = [[FYAVAssetReaderAudioMixOutput alloc] assetReaderTrackOutputWithReaser:self.kAssetReader mediaType:AVMediaTypeAudio];
        
        dispatch_group_enter(self.dispatch_group);
        [self.kAudioAssetWriterInput requestMediaDataWhenReadyOnQueue:self.dispatch_audio_queue usingBlock:^{
            while ([self.kAudioAssetWriterInput isReadyForMoreMediaData] && self.kAssetReader.status == AVAssetReaderStatusReading) {
                CMSampleBufferRef nextSampleBufferRef = [assetReaderAudioMixOutput copyNextSampleBuffer];
                if (nextSampleBufferRef) {
                    [self.kAudioAssetWriterInput appendSampleBuffer:nextSampleBufferRef];
                    CFRelease(nextSampleBufferRef);
                }else {
                    [self.kAudioAssetWriterInput markAsFinished];
                    dispatch_group_leave(self.dispatch_group);
                    break;
                }
            }
        }];
        
        self.kVideoAssetWriterInput = [self assetWriterInputWithMediaType:AVMediaTypeVideo];
        AVAssetReaderOutput *assetReaderTrackOutput = [[FYAVAssetReaderTrackOutput alloc] assetReaderTrackOutputWithReaser:self.kAssetReader mediaType:AVMediaTypeVideo];
        
        dispatch_group_enter(self.dispatch_group);
        [self.kVideoAssetWriterInput requestMediaDataWhenReadyOnQueue:self.dispatch_video_queue usingBlock:^{
            BOOL completionFailed = NO;
            while ([self.kVideoAssetWriterInput isReadyForMoreMediaData] && self.kAssetReader.status == AVAssetReaderStatusReading) {
                CMSampleBufferRef nextSampleBufferRef = [assetReaderTrackOutput copyNextSampleBuffer];
                NSError *outPutError = nil;
                if (NULL != nextSampleBufferRef) {
                    BOOL success = [self.kVideoAssetWriterInput appendSampleBuffer:nextSampleBufferRef];
                    CFRelease(nextSampleBufferRef);
                    nextSampleBufferRef = nil;
                    completionFailed = !success;
                    if (!success && self.kAssetWriter.status == AVAssetWriterStatusFailed) {
                        outPutError = self.kAssetWriter.error;
                    }
                }else {
                    if (self.kAssetReader.status == AVAssetReaderStatusFailed) {
                        outPutError = self.kAssetReader.error;
                    }else{
                        completionFailed = YES;
                    }
                }
                if (nil != outPutError) {
                    //TODO 不是程序奔溃，而这个方法使程序奔溃
                    NSString *reason = [NSString stringWithFormat:@"copyNextSampleBuffer is nil in %@ Method of Class %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
                    NSDictionary *userInfoDic = @{@"error":outPutError,
                                                  @"reason":reason};
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:userInfoDic];
                }
                if (completionFailed) {
                    [self.kVideoAssetWriterInput markAsFinished];
                    dispatch_group_leave(self.dispatch_group);
                    break;
                }
            }
        }];
        
        dispatch_group_notify(self.dispatch_group, dispatch_get_main_queue(), ^{
            [self.kAssetWriter finishWritingWithCompletionHandler:^{
                NSLog(@"加载完毕");
                NSString *saveFilePath = [[self saveVideoSourceIntoSandbox] absoluteString];
                [self saveToPhotoWith:saveFilePath];
            }];
        });
    } else {
        NSString *reason = [NSString stringWithFormat:@"AVAssetWriterOutput | AVAssetReaderOutput starting is error in %@ Method of Class %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
        NSDictionary *userInfoDic = @{@"error":outPutError,
                                      @"reason":reason};
        @try {
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

#pragma mark - privatedMethod

-(void)saveToPhotoWith:(NSString *)filePath {
    NSLog(@"保存");
    UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
}

- (NSURL *)saveVideoSourceIntoSandbox {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *stringSavedEditorVideo = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"slEditorVideo-%d.mov", arc4random() % 1000]];
    NSURL *urlSavedEditorVideo = [NSURL fileURLWithPath:stringSavedEditorVideo];
    return urlSavedEditorVideo;
}

- (AVAssetWriterInput *)assetWriterInputWithMediaType:(NSString *)mediaType {
    for (AVAssetWriterInput *assetWriterInput in self.kAssetWriter.inputs) {
        if ([assetWriterInput.mediaType isEqualToString:mediaType]) {
            return assetWriterInput;
        }
    }
    return nil;
}

@end
