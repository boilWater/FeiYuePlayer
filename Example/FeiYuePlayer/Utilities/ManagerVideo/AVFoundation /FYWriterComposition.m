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
    [self.kAssetReader startReading];
    [self.kAssetWriter startWriting];
    
    //设置开始读取的时间
    [self.kAssetWriter startSessionAtSourceTime:kCMTimeZero];
    
    AVAssetWriterInput *audioAssetWriterInput = [self assetWriterInputWithMediaType:AVMediaTypeAudio];
    AVAssetReaderOutput *assetReaderAudioMixOutput = [[FYAVAssetReaderAudioMixOutput alloc] assetReaderTrackOutputWithReaser:self.kAssetReader mediaType:AVMediaTypeAudio];
    
    dispatch_group_enter(self.dispatch_group);
    [audioAssetWriterInput requestMediaDataWhenReadyOnQueue:self.dispatch_audio_queue usingBlock:^{
        while ([audioAssetWriterInput isReadyForMoreMediaData] && self.kAssetReader.status == AVAssetReaderStatusReading) {
            CMSampleBufferRef nextSampleBufferRef = [assetReaderAudioMixOutput copyNextSampleBuffer];
            if (nextSampleBufferRef) {
                [audioAssetWriterInput appendSampleBuffer:nextSampleBufferRef];
                CFRelease(nextSampleBufferRef);
            }else {
                [audioAssetWriterInput markAsFinished];
                dispatch_group_leave(self.dispatch_group);
                break;
            }
        }
    }];
    
    AVAssetWriterInput *videoAssetWriterInput = [self assetWriterInputWithMediaType:AVMediaTypeVideo];
    AVAssetReaderOutput *assetReaderTrackOutput = [[FYAVAssetReaderTrackOutput alloc] assetReaderTrackOutputWithReaser:self.kAssetReader mediaType:AVMediaTypeVideo];
    
    dispatch_group_enter(self.dispatch_group);
    [videoAssetWriterInput requestMediaDataWhenReadyOnQueue:self.dispatch_video_queue usingBlock:^{
        while ([videoAssetWriterInput isReadyForMoreMediaData] && self.kAssetReader.status == AVAssetReaderStatusReading) {
            CMSampleBufferRef nextSampleBufferRef = [assetReaderTrackOutput copyNextSampleBuffer];
            if (nextSampleBufferRef) {
                BOOL success = [videoAssetWriterInput appendSampleBuffer:nextSampleBufferRef];
                CFRelease(nextSampleBufferRef);
                nextSampleBufferRef = nil;
                if (!success && self.kAssetWriter.status == AVAssetWriterStatusFailed) {
                    NSError *failureError = self.kAssetWriter.error;
                    
                }
            }else {
                if (self.kAssetReader.status == AVAssetReaderStatusFailed) {
//TODO SLWriterComposition
                    NSError *failureError = self.kAssetReader.error;
                }else{
                    [videoAssetWriterInput markAsFinished];
                    dispatch_group_leave(self.dispatch_group);
                    break;
                }
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
