//
//  FYAVAssetReaderOutput.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYAVAssetReaderOutput.h"

@implementation FYAVAssetReaderOutput

- (instancetype)assetReaderTrackOutputWithReaser:(AVAssetReader *)assetReader mediaType:(NSString *)mediaType {
    for (AVAssetReaderOutput *readerOutput in assetReader.outputs) {
        if ([readerOutput.mediaType isEqualToString:mediaType]) {
            return (FYAVAssetReaderOutput *)readerOutput;
        }
    }
    return nil;
}

@end


@implementation FYAVAssetReaderTrackOutput

- (instancetype)assetReaderTrackOutputWithReaser:(AVAssetReader *)assetReader mediaType:(NSString *)mediaType {
    for (AVAssetReaderTrackOutput *readerOutput in assetReader.outputs) {
        if ([readerOutput.mediaType isEqualToString:mediaType]) {
            return (FYAVAssetReaderTrackOutput *)readerOutput;
        }
    }
    return nil;
}

@end

@implementation FYAVAssetReaderAudioMixOutput

- (instancetype)assetReaderTrackOutputWithReaser:(AVAssetReader *)assetReader mediaType:(NSString *)mediaType {
    for (AVAssetReaderAudioMixOutput *readerOutput in assetReader.outputs) {
        if ([readerOutput.mediaType isEqualToString:mediaType]) {
            return (FYAVAssetReaderAudioMixOutput *)readerOutput;
        }
    }
    return nil;
}

@end

