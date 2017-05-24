//
//  FYAVAssetReader.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYAVAssetReader.h"
#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVVideoComposition.h>
#import <AVFoundation/AVAudioMix.h>
#import <AVFoundation/AVAssetReaderOutput.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CoreVideo/CVPixelBuffer.h>

@interface FYAVAssetReader ()

@property(nonatomic, strong) AVMutableComposition *kComposition;
@property(nonatomic, strong) AVMutableVideoComposition *kVideoComposition;
@property(nonatomic, strong) AVMutableAudioMix *kAudioMix;

@end

@implementation FYAVAssetReader

- (instancetype)initWithComposition:(AVMutableComposition *)composition
                   videoComposition:(AVMutableVideoComposition *)videoComposition
                           audioMix:(AVMutableAudioMix *)audioMix {
    NSError *error = nil;
    self = [super initWithAsset:composition error:&error];
    if (self) {
        self.kComposition = composition;
        self.kVideoComposition = videoComposition;
        self.kAudioMix = audioMix;
        [self initAVAssetReader];
    }
    return self;
}

#pragma mark - privatedMethod(initAVAssetReader)

- (void)initAVAssetReader {
    self.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(self.kComposition.duration.value, self.kComposition.duration.timescale));
    
    NSDictionary *videoOutputingSeeting = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    AVAssetReaderVideoCompositionOutput *assetReaderVideoCompositionOutput = [AVAssetReaderVideoCompositionOutput assetReaderVideoCompositionOutputWithVideoTracks:[self.kComposition tracksWithMediaType:AVMediaTypeVideo] videoSettings:videoOutputingSeeting];
    
#if ! TARGET_IPHONE_SIMULATOR
    if ([AVVideoComposition isKindOfClass:[AVMutableVideoComposition class]]) {
        [(AVMutableVideoComposition *)self.kVideoComposition setRenderScale:1.0];
    }
#endif
    
    assetReaderVideoCompositionOutput.videoComposition = self.kVideoComposition;
    assetReaderVideoCompositionOutput.alwaysCopiesSampleData = NO;
    [self addOutput:assetReaderVideoCompositionOutput];
    
    AVAssetReaderAudioMixOutput *assetReaderAudioMixOutput = nil;
    if ([[self.kComposition tracksWithMediaType:AVMediaTypeAudio] count] > 0) {
        assetReaderAudioMixOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:[self.kComposition tracksWithMediaType:AVMediaTypeAudio] audioSettings:nil];
        assetReaderAudioMixOutput.audioMix = self.kAudioMix;
        assetReaderVideoCompositionOutput.alwaysCopiesSampleData = NO;
        [self addOutput:assetReaderAudioMixOutput];
    }
}

@end
